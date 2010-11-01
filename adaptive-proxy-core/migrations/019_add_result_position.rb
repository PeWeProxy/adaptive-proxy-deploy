class AddResultPosition < ActiveRecord::Migration
  def self.up
    add_column :bf_recommendations, :position, :integer
  end

  def self.down
    remove_column :bf_recommendations, :position
  end
end
