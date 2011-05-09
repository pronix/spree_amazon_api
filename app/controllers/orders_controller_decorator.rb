OrdersController.class_eval do
  before_filter :check_amazon_product, :only => [:populate]

  private

  def check_amazon_product

    if params[:variants]
      @varian_params = params[:variants].dup
      params[:variants] = { }
      @varian_params.each do |variant_id, quantity|
        @spree_variant = Spree::Amazon::Product.save_to_spree_or_find(variant_id)
        params[:variants][@spree_variant.try(:master).try(:id)] = quantity
      end
    end
  end
end
