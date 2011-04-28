module Spree
  module Amazon
    class Taxon < Spree::Amazon::Base
      include ActiveModel::AttributeMethods
      extend ActiveModel::Callbacks
      attr_accessor :id, :parent_id, :is_parent, :name, :status, :data, :is_root
      alias :is_parent? :is_parent

      ROOT_TAXONS =
        [
         { :name => "Books",                :id => "283155" },
         { :name => "Music",                :id => "5174" },
         { :name => "DVD",                  :id => "2" },
         { :name => "Toys",                 :id => "165793011" },
         { :name => "Video Games",          :id => "4"},
         { :name => "Software",             :id => "5" },
         { :name => "Software Video Games", :id => "6"},
         { :name => "Electronics",          :id => "7"},
         { :name => "Tools",                :id => "8" },
         { :name => "Sporting Goods",       :id => "9"},
         { :name => "Art Supplies",         :id => "10"},
         { :name => "Kitchen",              :id => "11"},
         { :name => "Gourmet Food",         :id => "12"},
         { :name => "Apparel",              :id => "13"},
         { :name => "PC Hardware",          :id => "14"},
         { :name => "VHS",                  :id => "15"}
        ]

      class << self
        attr_accessor :root_category
        def root_category
          @root_category ||=  new(:name => "Category", :id => "0000", :is_root => true)
          @root_category
        end
        # Таксоны верхнего уровня
        #
        def roots
          [ root_category ]
        end

        def find(cid)
          new(ROOT_TAXONS.find{ |x| x[:id] == cid.to_s})
        end


        def search(options)

        end
      end # end class << self

      def data
        @data ||= SpreeEcs::Taxon.find(self.id)
        @data
      end

      # Products
      #
      def products
        [ ]
      end

      def root
        self.class.root_category
      end

      def permalink
        @id.to_s
      end

      def children
        # (data.doc/'browsenode/children/browsenode').collect{|x|
        #   self.class.new( { :id => (x/'browsenodeid/').to_s,
        #                     :name => (x/'name/').to_s,
        #                     :isroot => (x/'iscategoryroot/').to_s.to_i  }
        #                   )
        # }
        if is_root
          ROOT_TAXONS.map{ |x| self.class.new(x) }
        else
          []
        end

      end

      def parent
        nil
      end
      def ancestors
        # (data.doc/'browsenode/ancestors/browsenode').collect{|x|
        #   self.class.new( { :id => (x/'browsenodeid/').to_s,
        #                     :name => (x/'name/').to_s,
        #                     :isroot => (x/'iscategoryroot/').to_s.to_i  }
        #                   )
        # }
        [ ]
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
