class AddWiNews < ActiveRecord::Migration
  
  def self.up
  
    create_table :wi_news do |t|
      t.string :url, :limit => 1024, :null => false
      t.string :title, :null => false
    end
  
    create_table :wi_recommended_news do |t|
      t.integer :user_id, :null => false
      t.integer :news_id, :null => false
    end
    
    create_table :wi_recommendations_news do |t|
      t.string :userid, :limit => 32, :null => false
      t.string :code, :limit => 10000, :null => false
    end
    
  end
  
  def self.down
    drop_table :wi_news
    drop_table :wi_recommended_news
    drop_table :wi_recommendations_news    
  end
  
end