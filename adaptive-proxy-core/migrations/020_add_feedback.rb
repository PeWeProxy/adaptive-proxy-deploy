class AddFeedback < ActiveRecord::Migration
  def self.up
    add_column :bf_recommendation_groups, :clicked, :boolean
    add_column :bf_recommendation_groups, :clicked_at, :timestamp
    add_column :bf_recommendation_groups, :negative, :boolean
    add_column :bf_recommendation_groups, :negative_at, :timestamp
  end

  def self.down
    remove_column :bf_recommendation_groups, :clicked
    remove_column :bf_recommendation_groups, :clicked_at
    remove_column :bf_recommendation_groups, :negative
    remove_column :bf_recommendation_groups, :negative_at
  end
end
