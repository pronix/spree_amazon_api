class AddAmazonIdToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :amazon_id, :string
    add_index :products, :amazon_id
  end

  def self.down
    remove_column :products, :amazon_id
    remove_index :products, :amazon_id
  end
end
