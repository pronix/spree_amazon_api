module SpreeEcs
  class Product < SpreeEcs::Base

    class << self

      #
      def search(options={ })
        @query = options.delete(:q)||'*'
        Amazon::Ecs.item_search(@query, ({:response_group => "Large",  :search_index => 'All' }).merge(options))
      end

      #
      #
      def find(asin, options={ })
        Amazon::Ecs.item_lookup(asin, ({
                                         :response_group => "Large"
                                       }).merge(options))
      end

    end # end class << self

  end
end
