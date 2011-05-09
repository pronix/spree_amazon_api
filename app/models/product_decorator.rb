require 'open-uri'
Product.class_eval do
  class << self
    def save_from_amazon(options)
      if @spree_product = create!(options[:attributes])
        @master = @spree_product.master
        @master.send(:write_attribute, :price, options[:price] )
        (options[:images]||[]).map{ |image|
          @spree_product.images.create(:attachment => open(image.attachment.url(:large)))
        }
      end
      @spree_product
    end
  end # end class << self
end
