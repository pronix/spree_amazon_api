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
          new( SpreeEcs::Product.find(product_asin, { :response_group => "Large, Variations" }))
        end

        # Search products
        #
        def search(options={ })
          @results = SpreeEcs::Product.search(options)
          unless @results.blank?
            Spree::Amazon::ProductCollection.build({ :products => @results[:products].map { |item| new(item) },
                                                     :total_entries => @results[:total_entries],
                                                     :current_page => @results[:current_page] })
          else
            Spree::Amazon::ProductCollection.empty_build
          end
        end

      end # end class << self

      # Product images
      #
      def images
        @images.blank? ? [] : @images.map{ |x| Spree::Amazon::Image.new(x, @name) }
      end

      # Variants
      #
      def variants
        @_variants ||= Spree::Amazon::Variant.build_variants_collection(self, @variants)
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

