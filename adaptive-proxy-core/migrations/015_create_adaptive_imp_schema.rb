class CreateAdaptiveImpSchema < ActiveRecord::Migration
  
  def self.up
    
    create_table :wi_users do |t|
      t.string :userid, :limit => 32, :null => false
      
    end
    
    create_table :wi_pearson_coeffs, :id => false do |t|
      t.integer :user1, :null => false
      t.integer :user2, :null => false
      t.float :value, :null => false
    end
    
    create_table :wi_interest do |t|
      t.integer :user_id, :null => false
      t.string :url, :limit => 1024, :null => false
      t.float :value, :null => false
    end
    
    execute "ALTER TABLE wi_pearson_coeffs ADD PRIMARY KEY (user1, user2)"
  end
  
  def self.down
    drop_table :wi_users
    drop_table :wi_pearson_coeffs
    drop_table :wi_interest
  end
  
end