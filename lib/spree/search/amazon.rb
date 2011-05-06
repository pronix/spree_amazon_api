module Spree::Search
  class Amazon < Spree::Search::Base

    def retrieve_products
      curr_page = manage_pagination && keywords ? 1 : page
      options = {:item_page => curr_page , :page_size => 10 }

      if keywords # || @properties[:taxon].present?
        options.merge!({ :q => keywords}) if keywords
      end

      if @properties[:taxon].present?
        options.merge!({ :search_index => taxon.try(:search_index), :browse_node => taxon.try(:id) })
      end

      Spree::Amazon::Product.search(options)
    end

    def prepare(params)
      @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Amazon::Taxon.find(params[:taxon])
      @properties[:keywords] = params[:keywords]

      per_page = params[:per_page].to_i
      @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
      @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
    end


  end
end
