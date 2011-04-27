module Spree
  module Amazon
    class Taxon < Spree::Amazon::Base
      include ActiveModel::AttributeMethods
      extend ActiveModel::Callbacks
      attr_accessor :id, :parent_id, :is_parent, :name, :status
      alias :is_parent? :is_parent

      class << self

        # Таксоны верхнего уровня
        #
        def roots
          [

          ]
        end

        # Поиск таксона по ид
        #
        # == Parameters:
        # cid - ид категории
        #
        # == Returns:
        #
        def find(cid)
          nil
        end

        def mapped(taobao_category)
          {
            :name      => translator(taobao_category["name"] ),
            :status    => taobao_category["status"],
            :is_parent => taobao_category["is_parent"],
            :parent_id => taobao_category["parent_cid"],
            :id        => taobao_category["cid"]
          }
        end

        def search(options)

        end
      end # end class << self


      # Получить список товаров для категории
      #
      #
      def products
        [ ]
      end

      def root
        self
      end
      def permalink
        @id.to_s
      end

      def children
        []
      end

      def parent
        nil
      end
      def ancestors
        [  ]
      end

      def self_and_descendants
        [ self ].compact
      end

    end
  end
end
