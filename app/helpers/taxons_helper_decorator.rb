TaxonsHelper.class_eval do

  def taxon_preview(taxon, max=5)
    taxon.products[0..max]
  end


end
