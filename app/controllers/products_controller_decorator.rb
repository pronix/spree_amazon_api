ProductsController.class_eval do

  private

  def object
    @object = Spree::Amazon::Product.find(params[:id])
  end

  def load_data
    @product =  Spree::Amazon::Product.find(params[:id])
    @variants = @product.variants
    @product_properties = []
    @selected_variant = @variants.first
  end

end
