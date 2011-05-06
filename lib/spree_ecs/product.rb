module SpreeEcs
  class Product < SpreeEcs::Base

    class << self

      # Search products
      #
      def search(options={ })
        @query = options.delete(:q)|| (options[:browse_node] ? '' : '*')
        options[:sort] = "salesrank" if options[:search_index] && options[:search_index].to_s != 'All'
        @options = ({:response_group => "Large",  :search_index => 'Books' }).merge(options)
        puts '-'*90
        puts @options.inspect
        Amazon::Ecs.item_search(@query, @options)
      end

      # Find product by asin
      #
      def find(asin, options={ })
        Amazon::Ecs.item_lookup(asin, ({ :response_group => "Large" }).merge(options))
      end

    end # end class << self

  end
end
