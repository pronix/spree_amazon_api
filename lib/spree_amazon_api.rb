require 'spree_core'
require 'spree_amazon_api_hooks'
require "amazon/ecs"

module SpreeAmazonApi
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      # if Spree::Config.instance
      #   Spree::Config.searcher_class = Spree::Search::Amazon
      # end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      require File.join(File.dirname(__FILE__), "../lib/spree_ecs.rb")
      Ability.register_ability(AmazonAbility)


      Amazon::Ecs.configure do |options|
        options[:aWS_access_key_id]        = "AKIAIPGT64K6EM74JYIQ"
        options[:aWS_secret_key]           = "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"
        options[:response_group]           = 'Large'
      end



      Spree::Search::Base.class_eval do

        def retrieve_products
          curr_page = manage_pagination && keywords ? 1 : page
          options = {:item_page => curr_page , :page_size => 12 }

          if keywords || @properties[:taxon].present?
            options.merge!({ :q => keywords}) if keywords
            # options.merge!({ :cid => taxon.try(:id)}) unless @properties[:taxon].blank?
          end

          Spree::Amazon::Product.search(options)
        end
      end



    end

    config.to_prepare &method(:activate).to_proc
  end
end
