require 'open-uri'
module Spree
  module Amazon

    class Product < Spree::Amazon::Base

      attr_accessor :price, :name, :taxon_id, :id, :description, :images, :url, :variants
      attr_accessor :taxon_name, :binds, :props_str, :sale_props, :props, :created_at, :updated_at
      attr_accessor :variant_options, :variant_attributes

      class << self

        def class_name
          "Spree::Amazon::Product"
        end

        def name
          "Product"
        end

        def prepare_id(product_id)
          product_id.to_s
        end

        # Product for home page
        def root_page
          self.search(:q => "*")
        end

        # Find product by ASIN
        #
        def find(product_asin)
          new(mapped(SpreeEcs::Product.find(product_asin, { :response_group => "Large, Variations" }).items.first))
        end

        # Search products
        #
        def search(options={ })
          @result = SpreeEcs::Product.search(options)
          unless @result.has_error?
            @collection = Spree::Amazon::ProductCollection.new( @result.items.map { |item| new(mapped(item)) }||[] )
            @collection.total_entries =  @result.total_pages
            @collection.current_page  = @result.item_page
          else
            @collection =  Spree::Amazon::ProductCollection.new([])
            @collection.total_entries =  1
            @collection.current_page = 1
          end
          return @collection.compact
        end

        private

        #
        #
        def mapped(product_attributes)
          {
            :name        => product_attributes.get('itemattributes/title'),
            :description => product_attributes.get('editorialreviews/editorialreview/content'),
            :id          => product_attributes.get('asin'),
            :price       => (product_attributes.get('formattedprice').gsub(/\$|,|\ /,'').to_f rescue 0),
            :url         => product_attributes.get('detailpageurl'),
            :images      => parse_images(product_attributes),
            :variants    => parse_variants(product_attributes),
            :variant_options => parse_variant_options(product_attributes),
            :variant_attributes => parse_variant_attributes(product_attributes),
          }
        end

        #
        #
        def parse_images(product_attributes)

          result_images = [{ :small   => product_attributes.get('smallimage/url'),
                             :mini    => product_attributes.get('smallimage/url'),
                             :product => product_attributes.get('mediumimage/url'),
                             :large   => product_attributes.get('largeimage/url') } ]
          @imagesets = product_attributes.get_element("imagesets").get_elements("imageset") rescue nil
          unless @imagesets.blank?
            @imagesets.each do |imageset|
              if imageset.attributes['category'].to_s =~ /variant/
                result_images << {
                  :mini => imageset.get_hash("smallimage")[:url],
                  :small => imageset.get_hash("smallimage")[:url],
                  :product => imageset.get_hash("mediumimage")[:url],
                  :large => imageset.get_hash("largeimage")[:url]
                }
              end
            end
          end
          return result_images
        end

        #
        #
        def parse_variants(product_attributes)
          if product_attributes.get("variations/totalvariations").to_i  > 0
            product_attributes.get_elements("variations/item").map{ |v| mapped(v) }
          else
            []
          end
        end

        #
        #
        def parse_variant_options(product_attributes)
          product_attributes.get_elements("variationattributes/variationattribute").map(&:get_hash)
        rescue
          [ ]
        end

        def parse_variant_attributes(product_attributes)
          product_attributes.get_element("itemattributes").get_hash
        rescue
          []
        end

      end # end class << self

      # Product images
      #
      def images
        (@images||[]).map{ |x| Spree::Amazon::Image.new(x, @name) }
      end

      # Variants
      #
      def variants
        @_variants ||= Spree::Amazon::VariantCollection.new((@variants||[]).map{ |x|
                                                              Spree::Amazon::Variant.new(x.merge(:product => self)) })
        @_variants
      end

      def has_variants?
        !@variants.blank?
      end

      def available?
        true
      end

      def possible_promotions
        [ false ]
      end

      def has_stock?
        true
      end

      def master
        self
      end

      def taxons
        [ Spree::Amazon::Taxon.find(self.taxon_id) ].compact
      end

      def price
        @price
      end


      def to_param
        "#{self.id}"
      end


    end
  end


end

