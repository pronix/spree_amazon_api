Taxon.class_eval do
  class << self

    def roots
      Spree::Amazon::Taxon.roots
    end

    def find(taxon_id)
      Spree::Amazon::Taxon.find(taxon_id)
    end

  end
end
