ProductsController.class_eval do

  private

  def object
    @object = Product.find_by_permalink(params[:id]) || Spree::Amazon::Product.find(params[:id])
  end

  def load_data
    if @product = Product.find_by_permalink(params[:id])
      load_object
      @variants = Variant.active.find_all_by_product_id(@product.id,  :include => [:option_values, :images])
      @product_properties = ProductProperty.find_all_by_product_id(@product.id,  :include => [:property])
      @selected_variant = @variants.detect { |v| v.available? }

      referer = request.env['HTTP_REFERER']

      if referer  && referer.match(ProductsController::HTTP_REFERER_REGEXP)
        @taxon = Taxon.find_by_permalink($1)
      end

    else
      @product =  Spree::Amazon::Product.find(params[:id])
      @variants = @product.variants
      @product_properties = []
      @selected_variant = @variants.first
    end

  end

end
