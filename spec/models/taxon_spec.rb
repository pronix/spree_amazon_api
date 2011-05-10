require File.dirname(__FILE__) + '/../spec_helper'

describe Taxon do

  it "should rerunt root taxons" do
    Taxon.roots.map(&:name).should ==
      YAML.load( File.open(File.join( Rails.root, 'db', 'amazon_categories.yml' )  ) ).map{ |v| v[:name]}
  end

  context "Find taxon" do

    it "should return amazon taxon" do
      @taxon = Taxon.find(130)
      @taxon.should be_present
      @taxon.class.should == Spree::Amazon::Taxon
      @taxon.name.should == "Movies & TV"
      @taxon.id.to_s.should == "130"
    end
  end
end
