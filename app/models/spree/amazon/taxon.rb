module Spree
  module Amazon
    class Taxon < Spree::Amazon::Base
      include ActiveModel::AttributeMethods
      extend ActiveModel::Callbacks
      attr_accessor :id, :parent_id, :is_parent, :name, :status, :data, :is_root, :search_index, :children
      attr_accessor :children, :ancestors
      alias :is_parent? :is_parent


      ROOT_TAXONS = YAML.load( File.open(File.join(File.dirname(__FILE__), "../../../../data/category.yml")  ) )


      class << self
        attr_accessor :root_category

        def root_category
          @root_category ||=  new(:name => "Category", :id => "0000", :is_root => true)
          @root_category
        end

        # Таксоны верхнего уровня
        #
        def roots
          ROOT_TAXONS.map{ |x| new(SpreeEcs::Taxon.find(x[:id])) }
        end

        def find(cid)
          roots.find{ |x| x.id.to_s == cid.to_s} ||  new(SpreeEcs::Taxon.find(cid))
        end


      end # end class << self

      def data
        @data ||= SpreeEcs::Taxon.find(self.id)
        @data
      end

      # Products
      #
      def products
        Spree::Amazon::Product.search( { :q => '', :browse_node => self.id })
      end

      def root
        self.class.root_category
      end

      def permalink
        @id.to_s
      end

      def children
        if @is_root
           ROOT_TAXONS.map{ |x| self.class.new(x) }
        else
          @_children ||= (@children||[ ]).map{ |v| self.class.new(v)}
          @_children
        end
      end

      def parent
        @parent_id ? SpreeEcs::Taxon.find(parent_id) : nil
      end

      def ancestors
        @_ancestors ||=(@ancestors||[]).map{ |v| self.class.new(v)} || []
        @_ancestors
      end

      def self_and_descendants
        [ self, ancestors ].flatten.compact
      end
      def applicable_filters
        [ ]
      end
    end
  end
end
