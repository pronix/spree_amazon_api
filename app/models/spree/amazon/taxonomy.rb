module Spree
  module Amazon
    class Taxonomy < Spree::Amazon::Base
      include ActiveModel::AttributeMethods
      extend ActiveModel::Callbacks
      attr_accessor :id,  :name

      def root
        Spree::Amazon::Taxon.root_category
      end

      class << self
        def roots
          [ new(:id => 1, :name => "Categories") ]
        end
      end # end class << self

    end

  end
end
