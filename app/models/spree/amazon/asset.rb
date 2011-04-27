module Spree
  module Amazon
    class Asset < Spree::Amazon::Base
      attr_accessor :url

      def url(style = :product)
        @url[style.to_sym]
      end

      def initialize(_url)
        @url = _url
      end

    end
  end
end
