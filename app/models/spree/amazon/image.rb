module Spree
  module Amazon
    class Image < Spree::Amazon::Base

      attr_accessor :alt, :attachment


      def initialize(url, _alt = nil)
        @attachment = Spree::Amazon::Asset.new(url)
        @alt = _alt.to_s
      end
    end
  end
end
