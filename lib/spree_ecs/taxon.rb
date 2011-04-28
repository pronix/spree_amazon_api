module SpreeEcs
  class Taxon < SpreeEcs::Base
    class << self

      # Find category by BrowseNodeId
      #
      def find(id)
        Amazon::Ecs.browse_node_lookup(id)
      end
    end # end class << self
  end
end
