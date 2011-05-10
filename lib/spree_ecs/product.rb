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
          log "search products query:#{ @query} || options #{options.inspect}"
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
          log("find product asin:#{asin} || options: #{options.inspect}")
          mapped(Amazon::Ecs.item_lookup(asin, ({ :response_group => "Large, Accessories" }).merge(options)).items.first)
        end
      end

      # MultiFind product by asin
      #
      def multi_find(asins, options={ })
        cache("spree_ecs:product:multifind:#{asins}:#{options.stringify_keys.sort}") do
          log(" multi find product asin:#{asins} || options: #{options.inspect}")
          Amazon::Ecs.item_lookup(asins, ({ :response_group => "Large, Accessories" }).merge(options)).items.map{|v| mapped(v) }
        end
      end

      private

      #
      #
      def mapped(item)
        {
          :name        => item.get('ItemAttributes/Title'),
          :description => item.get('EditorialReviews/EditorialReview/Content'),
          :id          => item.get('ASIN'),
          :price       => (item.get('OfferSummary/LowestNewPrice/FormattedPrice').gsub(/\$|,|\ /,'').to_f rescue 0),
          :url         => item.get('DetailPageURL'),
          :taxons      => parse_taxons(item),
          :images      => parse_images(item),
          :variants    => parse_variants(item),
          :variant_options => parse_variant_options(item),
          :variant_attributes => parse_variant_attributes(item)
        }
      end

      def parse_taxons(item)
        @_taxons = []
        item.get_elements("Ancestors").each{|x|
          @node_name  = (x/"BrowseNode").at("Name").text
          @node_id    = (x/"BrowseNode").at("BrowseNodeId/").text
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
        unless item.get('SmallImage/URL').blank?
          result_images  << {
            :small   => item.get('SmallImage/URL'),
            :mini    => item.get('SmallImage/URL'),
            :product => item.get('MediumImage/URL'),
            :large   => item.get('LargeImage/URL')
          }
        end
        @imagesets = item.get_element("ImageSets").get_elements("ImageSet") rescue nil
        unless @imagesets.blank?
          @imagesets.each do |imageset|
            if imageset.attributes['category'].to_s =~ /variant/
              result_images << {
                :mini => imageset.get_hash("SmallImage")[:url],
                :small => imageset.get_hash("SmallImage")[:url],
                :product => imageset.get_hash("MediumImage")[:url],
                :large => imageset.get_hash("LargeImage")[:url]
              }
            end
          end
        end
        return result_images
      end

      #
      #
      def parse_variants(item)
        if item.get("Variations/TotalVariations").to_i  > 0
          item.get_elements("Variations/Item").map{ |v| mapped(v) }
        else
          []
        end
      end

      #
      #
      def parse_variant_options(item)
        item.get_elements("VariationAttributes/VariationAttribute").map(&:get_hash)
      rescue
        [ ]
      end

      def parse_variant_attributes(item)
        item.get_element("ItemAttributes").get_hash
      rescue
        []
      end





    end # end class << self

  end
end
