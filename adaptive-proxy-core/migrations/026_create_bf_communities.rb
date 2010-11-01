class CreateBfCommunities < ActiveRecord::Migration
  def self.up
    create_table :bf_communities do |t|
      t.string :owner, :limit => 32
      t.text :friends
    end
  end

  def self.down
    drop_table :bf_communities
  end
end
