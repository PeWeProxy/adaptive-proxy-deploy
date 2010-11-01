class AddClicks < ActiveRecord::Migration
  def self.up
    add_column :bf_recommendations, :clicked, :boolean
    add_column :bf_recommendations, :clicked_at, :timestamp
  end

  def self.down
    remove_column :bf_recommendations, :clicked
    remove_column :bf_recommendations, :clicked_at
  end
end
