 Spree <-> Amazon
===========================================

Installation
------------

Add to Gemfile:
  gem "spree_amazon_api", :git => "git@github.com:pronix/spree_amazon_api.git"

run task:
   rake spree_amazon_api:install

run migrate: (add amazon_id to product table)
   rake db:migrate

Root taxons define in file: db/amazon_categories.yml

Configure Amazon access:
-----------------------
Setting amazon options in amazon.yml file( Rails.root/config).

example:

    development:
      :configure:                                                  # acces options
    :aWS_access_key_id: 0XQXXC6YV2C85DX1BF02
    :aWS_secret_key: fwLOn0Y/IUXEM8Hk49o7QJV+ryOscbhXRb6CmA5l
    :response_group: 'Large'
    :country: 'us'                                             # region
       :query:                                                      # search options
         :q: "%{q}"                                                 # %{q} replace on user keywords
         :options:
            :search_index: 'Books'
            :response_group: 'Large, Accessories'
            :sort: "salesrank"                                       # default sort

    production:
      :configure:
        :aWS_access_key_id: 0XQXXC6YV2C85DX1BF02
        :aWS_secret_key: fwLOn0Y/IUXEM8Hk49o7QJV+ryOscbhXRb6CmA5l
        :response_group: 'Large'
        :country: 'us'
      :query:
        :q: "%{q}"
        :options:
          :search_index: 'Books'
          :response_group: 'Large, Accessories'
          :sort: "salesrank"

