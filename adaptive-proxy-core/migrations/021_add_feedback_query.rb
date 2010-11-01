class AddFeedbackQuery < ActiveRecord::Migration
  def self.up
    add_column :bf_recommendation_groups, :clicked_query, :string
    add_index :bf_recommendation_groups, [:id, :clicked_query]
  end

  def self.down
    remove_column :bf_recommendation_groups, :clicked_query
    remove_index :bf_recommendation_groups, :column => [:id, :clicked_query]
  end
end
