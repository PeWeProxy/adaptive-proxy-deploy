class ReferencePageFromFeedback < ActiveRecord::Migration
  def self.up
    remove_column :wi_feedback, :url
    add_column :wi_feedback, :page_id, :integer, :null => false
  end
  
  def self.down
    add_column :wi_feedback, :url, :string, :limit => 1024, :null => false 
    remove_column :wi_feedback, :page_id
  end
end