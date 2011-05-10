require File.dirname(__FILE__) + '/../spec_helper'

describe Product do
  it "should save product in spree base from amazon" do
    Product.save_from_amazon({ :attributes =>{
                                 :amazon_id      => "B001TH7GSW",
                                 :sku            => "B001TH7GSW",
                                 :name           => "Toslink Digital Audio Optical Cable",
                                 :count_on_hand  => 10,
                                 :available_on   => 1.day.ago,
                                 :description    => "AmazonBasics products are quality electronics ......",
                                 :price          => 19.9
                               },
                               :price => 19.9,
                               :images =>[ ]
                             })
    @product = Product.find_by_amazon_id("B001TH7GSW")
    @product.should be_present
    @product.name.should == "Toslink Digital Audio Optical Cable"
    @product.price.should == 19.9
  end

end
