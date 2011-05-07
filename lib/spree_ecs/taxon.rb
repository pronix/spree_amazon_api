module SpreeEcs
  class Taxon < SpreeEcs::Base
    class << self

      # Find category by BrowseNodeId
      #
      def find(id)
        Rails.cache.fetch("spree_ecs:taxon:#{id}") { parse_browse_node(Amazon::Ecs.browse_node_lookup(id)) }
      end

      private

      def parse_browse_node(raw_data)
        doc = raw_data.doc
        browse_node_id  = (doc/'browsenodes/browsenode/browsenodeid/').to_s
        {
          :name => (doc/'browsenodes/browsenode/name/').to_s.gsub('&amp;', '&'),
          :id => browse_node_id,
          :search_index => "Books",
          :children => children(browse_node_id, doc),
          :ancestors => []
        }
      end

      def children(browse_node_id, doc)
        (doc/'browsenodes/browsenode/children/browsenode').map{|v|
          {
            :name         => (v/'name/').to_s.to_s.gsub('&amp;', '&'),
            :id           => (v/'browsenodeid/').to_s,
            :search_index => "Books",
            :parent_id    => browse_node_id
          }
        }

      end

      def ancestors(doc)
        # (data.doc/'browsenode/ancestors/browsenode').collect{|x|
        #   self.class.new( { :id => (x/'browsenodeid/').to_s,
        #                     :name => (x/'name/').to_s,
        #                     :isroot => (x/'iscategoryroot/').to_s.to_i  }
        #                   )
        # }
        [ ]
      end

    end # end class << self
  end
end
