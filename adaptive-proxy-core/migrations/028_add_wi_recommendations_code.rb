class AddWiRecommendationsCode < ActiveRecord::Migration
  
  def self.up    
    create_table :wi_recommendations do |t|    
      t.string :userid, :limit => 32, :null => false
      t.string :code, :limit => 10000, :null => false    
    end    
  end
  
  def self.down    
    drop_table :wi_recommendations
  end
  
end