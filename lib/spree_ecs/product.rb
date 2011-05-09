module SpreeEcs
  class Product < SpreeEcs::Base

    class << self

      # Search products
      #
      def search(options={ })

        @query = options.delete(:q) || (options[:browse_node] ? '' : '*')
        @options = (Spree::Config.amazon_options[:query][:options]).merge(options)
        @options.delete(:sort) if @options[:search_index] && @options[:search_index].to_s == 'All'
        @query = Spree::Config.amazon_options[:query][:q].to_s.gsub("%{q}", @query )
        cache("spree_ecs:product:search:#{@query }:#{@options.stringify_keys.sort}" ) {
          @response = Amazon::Ecs.item_search(@query, @options)
          {
            :total_entries => @response.total_pages,
            :current_page => (@response.item_page.to_i == 0 ? 1 : @response.item_page.to_i),
            :products => @response.items.map{ |item| mapped(item) }
          }
        }
      end

      # Find product by asin
      #
      def find(asin, options={ })
        cache("spree_ecs:product:find:#{asin}:#{options.stringify_keys.sort}") do
          mapped(Amazon::Ecs.item_lookup(asin, ({ :response_group => "Large, Accessories" }).merge(options)).items.first )
        end
      end

      private

      #
      #
      def mapped(item)
        {
          :name        => item.get('itemattributes/title'),
          :description => item.get('editorialreviews/editorialreview/content'),
          :id          => item.get('asin'),
          :price       => (item.get('formattedprice').gsub(/\$|,|\ /,'').to_f rescue 0),
          :url         => item.get('detailpageurl'),
          :taxons      => parse_taxons(item),
          :images      => parse_images(item),
          :variants    => parse_variants(item),
          :variant_options => parse_variant_options(item),
          :variant_attributes => parse_variant_attributes(item)
        }
      end

      def parse_taxons(item)
        @_taxons = []
        item.get_elements("ancestors").each{|x|
          @node_name  = (x/"browsenode").at("name/").to_s
          @node_id    = (x/"browsenode").at("browsenodeid/").to_s
          if !@node_name.blank? &&
              @node_name !~ /products|categories|features/i &&
              !@_taxons.map{|v| v[:id] }.include?(@node_id)
            @_taxons << { :name => @node_name, :id => @node_id, :search_index => "Books"  }
          end
        }
        @_taxons
      rescue
        []
      end
      #
      #
      def parse_images(item)
        result_images = []
        unless item.get('smallimage/url').blank?
          result_images  << {
            :small   => item.get('smallimage/url'),
            :mini    => item.get('smallimage/url'),
            :product => item.get('mediumimage/url'),
            :large   => item.get('largeimage/url')
          }
        end
        @imagesets = item.get_element("imagesets").get_elements("imageset") rescue nil
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
      def parse_variants(item)
        if item.get("variations/totalvariations").to_i  > 0
          item.get_elements("variations/item").map{ |v| mapped(v) }
        else
          []
        end
      end

      #
      #
      def parse_variant_options(item)
        item.get_elements("variationattributes/variationattribute").map(&:get_hash)
      rescue
        [ ]
      end

      def parse_variant_attributes(item)
        item.get_element("itemattributes").get_hash
      rescue
        []
      end





    end # end class << self

  end
end
