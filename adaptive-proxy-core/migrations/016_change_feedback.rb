class ChangeFeedback < ActiveRecord::Migration
  def self.up
    remove_column :wi_feedback, :rating
    add_column :wi_feedback, :positive_feedback, :integer
    add_column :wi_feedback, :negative_feedback, :integer
  end
  
  def self.down
    add_column :wi_feedback, :rating, :integer, :limit => 4, :null => false
    remove_column :wi_feedback, :positive_feedback
    remove_column :wi_feedback, :negative_feedback
  end
end