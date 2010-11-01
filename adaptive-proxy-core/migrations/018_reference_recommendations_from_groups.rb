class ReferenceRecommendationsFromGroups < ActiveRecord::Migration
  def self.up
    add_column :bf_recommendations, :groupid, :integer
    add_index :bf_recommendations, :groupid
  end

  def self.down
    remove_index :bf_recommendations, :groupid
    remove_column :bf_recommendations, :groupid
  end
end
