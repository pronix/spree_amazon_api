module Spree
  module Amazon
    class Taxon < Spree::Amazon::Base
      include ActiveModel::AttributeMethods
      extend ActiveModel::Callbacks
      attr_accessor :id, :parent_id, :is_parent, :name, :status, :data, :is_root, :search_index
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
          [ root_category ]
        end

        def find(cid)
          new(ROOT_TAXONS.find{ |x| x[:id].to_s == cid.to_s}||mapping(SpreeEcs::Taxon.find(cid)))
        end



        def mapping(raw_browse_node)
          doc = raw_browse_node.doc
          { :name => (doc/'browsenodes/browsenode/name/').to_s.gsub('&amp;', '&'),
            :id => (doc/'browsenodes/browsenode/browsenodeid/').to_s,
            :search_index => "Books"
          }

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

      # (s.doc/'browsenodes/browsenode/children/browsenode').map{|v| { :name => (v/'name/').to_s, :id => (v/'browsenodeid/').to_s } }

      def children
        if @is_root
           ROOT_TAXONS.map{ |x| self.class.new(x) }
         else
          if children_category_id = ( (((data.doc/'browsenode/children/browsenode').find{ |x| (x/'name/').to_s == "Categories" })/'browsenodeid/').to_s rescue nil)
            (SpreeEcs::Taxon.find(children_category_id).doc/'browsenode/children/browsenode').collect{|x|
              self.class.new({ :id => (x/'browsenodeid/').to_s,
                               :name => (x/'name/').to_s.gsub('&amp;', '&'),
                               :search_index => self.search_index,
                               :parent_id => self.id
                             })
            }
          else
            (data.doc/'browsenodes/browsenode/children/browsenode').map{|v|
              self.class.new({ :name => (v/'name/').to_s, :id => (v/'browsenodeid/').to_s,
                               :search_index => self.search_index, :parent_id => self.id})
            }
          end
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
