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

        (doc/"ancestors").map{ |v| parse_browse_node(v/"browsenode")}
      rescue
        []
      end
      def parse_ancestor_node(node)
        { :name => node.at('name/').to_s.to_s.gsub('&amp;', '&'), :id => node.at('browsenodeid/')     }
      end
    end # end class << self
  end
end
