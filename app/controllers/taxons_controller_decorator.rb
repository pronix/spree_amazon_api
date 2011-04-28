TaxonsController.class_eval do

  private
  def object
    @object ||= Spree::Amazon::Taxon.find(params[:id])
    @object
  end
end
