Spree::BaseController.class_eval do

  def get_taxonomies
    @taxonomies = Spree::Amazon::Taxon.roots
  end


end


