 Spree <-> Amazon
===========================================

Installation
------------

Add to Gemfile:
  gem "spree_amazon_api", :git => "git@github.com:pronix/spree_amazon_api.git"

run task:
   rake spree_amazon_api:install

run migrate: (add amazon_id to product table)


Configure Amazon access:
-----------------------
Change access key in amazon.yml file.( Rails.root/config)

example:

  development:

    access_key_id: 0XQXXC6YV2C85DX1BF02

    secret_key: fwLOn0Y/IUXEM8Hk49o7QJV+ryOscbhXRb6CmA5l

  production:
    access_key_id: 0XQXXC6YV2C85DX1BF02

    secret_key: fwLOn0Y/IUXEM8Hk49o7QJV+ryOscbhXRb6CmA5l
