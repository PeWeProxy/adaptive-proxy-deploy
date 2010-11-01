class AddWiRecommendations < ActiveRecord::Migration
  
  def self.up
  
    create_table :wi_recommended_pages do |t|
      t.integer :user_id, :null => false
      t.integer :page_id, :null => false
    end
    
    create_table :wi_recommended_events do |t|
      t.integer :user_id, :null => false
      t.integer :event_id, :null => false
    end    
    
  end
  
  def self.down
    drop_table :wi_recommended_pages
    drop_table :wi_recommended_events    
  end
  
end