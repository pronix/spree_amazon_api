TaxonsController.class_eval do

  def show
    @taxon = Spree::Amazon::Taxon.find(params[:id])
    return unless @taxon

    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
    @products = @searcher.retrieve_products

    respond_with(@taxon)
  end

end
