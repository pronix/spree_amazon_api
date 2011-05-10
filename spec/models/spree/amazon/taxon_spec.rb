require File.dirname(__FILE__) + '/../../../spec_helper'

describe Spree::Amazon::Taxon do
  context "find taxon" do
    it "should return roots taxony" do
      @root_taxons =  Spree::Amazon::Taxon.roots
      @root_taxons.map(&:name).should == YAML.load( File.open(File.join( Rails.root, 'db', 'amazon_categories.yml' )  ) ).map{ |v| v[:name]}

    end
    it "should return taxon" do
      @taxon = Spree::Amazon::Taxon.find("565108")
      @taxon.should be_present
      @taxon.class.should == Spree::Amazon::Taxon
      @taxon.name.should  =="Laptops"
      @taxon.id.should    =="565108"
    end
  end

  it "should return products in current taxon" do
    @taxon = Spree::Amazon::Taxon.find("565108")
    @taxon.products.should be_present
  end

  it "permalink taxon" do
    @taxon = Spree::Amazon::Taxon.find("565108")
    @taxon.permalink.should == "565108"
  end
  it "children" do
    @taxon = Spree::Amazon::Taxon.find("284507")
    @taxon.children.should be_present
    @taxon.children.map(&:name).should include("Bakeware")
  end

  it "parent taxon" do
    @taxon = Spree::Amazon::Taxon.find("289816")
    @taxon.parent.should be_present
    @taxon.parent.name.should == "Cookware"
  end

  it "ancestors" do
    @taxon = Spree::Amazon::Taxon.find("289816")
    @taxon.ancestors.should be_present
    @taxon.ancestors.map(&:name).should include("Cookware","Kitchen & Dining", "Home, Garden & Pets")
  end

  it "self_and_descendants" do
    @taxon = Spree::Amazon::Taxon.find("289816")
    @taxon.self_and_descendants.map(&:id).should include("289816")
  end

  it "check is root taxon" do
    @root_taxons =  Spree::Amazon::Taxon.roots
    @root_taxons[0].is_root.should be_true
  end
end
