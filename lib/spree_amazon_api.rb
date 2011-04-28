require 'spree_core'
require 'spree_amazon_api_hooks'
require "amazon/ecs"
require 'yaml'
module SpreeAmazonApi
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate

      Spree::Config.searcher_class = Spree::Search::Amazon if Spree::Config.instance

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      require File.join(File.dirname(__FILE__), "../lib/spree_ecs.rb")
      Ability.register_ability(AmazonAbility)

      amazon_options = YAML.load(File.open(File.join(Rails.root,'config', 'amazon.yml')))[Rails.env]
      Amazon::Ecs.configure do |options|
        options[:aWS_access_key_id]        = amazon_options["access_key_id"]
        options[:aWS_secret_key]           = amazon_options["secret_key"]
        options[:response_group]           = 'Large'
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
