require File.dirname(__FILE__) + '/../../../spec_helper'

describe Spree::Amazon::Taxonomy do

  it "root taxonomy" do
    @root_taxonomy = Spree::Amazon::Taxonomy.roots[0].root
    @root_taxonomy.should be_present
    @root_taxonomy.id.should == "0000"
    @root_taxonomy.name.should == "Categories"
  end

  it "roots taxonomies" do
    @roots_taxonomies = Spree::Amazon::Taxonomy.roots
    @roots_taxonomies.size.should == 1
    @roots_taxonomies[0].id.should == 1
    @roots_taxonomies[0].name.should == "Categories"
  end
end
