require 'spree_core'
require 'spree_amazon_api_hooks'
require "amazon/ecs"
require 'yaml'
module SpreeAmazonApi
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      # amazon_options = YAML.load(File.open(File.join(Rails.root,'config', 'amazon.yml')))[Rails.env]

      Spree::Config.searcher_class = Spree::Search::Amazon if Spree::Config.instance

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      require File.join(File.dirname(__FILE__), "../lib/spree_ecs.rb")
      Ability.register_ability(AmazonAbility)



      AppConfiguration.class_eval do
        preference :redirect_to_amazon, :boolean,  :default => false
      end

      Spree::Config.class_eval do
        class << self
          def amazon_options
            @@amazon_options ||= YAML.load(File.open(File.join(Rails.root,'config', 'amazon.yml')))[Rails.env]

            @@amazon_options
          end
        end # end class << self
      end

      Amazon::Ecs.configure do |options|
        options[:aWS_access_key_id]        = Spree::Config.amazon_options[:configure][:aWS_access_key_id]
        options[:aWS_secret_key]           = Spree::Config.amazon_options[:configure][:aWS_secret_key]
        options[:response_group]           = Spree::Config.amazon_options[:configure][:response_group] || 'Large'
        options[:country]                  = Spree::Config.amazon_options[:configure][:country] || 'us'
      end

    end

    config.to_prepare &method(:activate).to_proc
  end
end
