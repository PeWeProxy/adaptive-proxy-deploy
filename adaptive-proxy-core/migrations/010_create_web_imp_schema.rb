class CreateWebImpSchema < ActiveRecord::Migration
  
  def self.up
    create_table :wi_pages do |t|
      t.text :content, :limit => 4194304, :null => false
      t.string :url, :limit => 1024, :null => false
      t.string :heading, :limit => 512
      t.string :title, :limit => 512
      t.timestamp :date_time_accessed, :null => false
    end
    
    create_table :wi_links do |t|
      t.string :url, :limit => 1024, :null => false
      t.boolean :is_broken, :default => true
    end
    
    create_table :wi_page_link, :id => false do |t|
      t.integer :page_id, :null => false
      t.integer :link_id, :null => false
    end
    
    create_table :wi_feedback do |t|
      t.string :userid, :limit => 32, :null => false
      t.string :url, :limit => 1024, :null => false
      t.integer :rating, :limit => 4, :null => false      
      t.timestamp :timestamp, :null => false
    end
    
    create_table :wi_events do |t|
      t.integer :page_id, :null => false
      t.string :name, :limit => 128, :null => false
      t.string :caption, :limit => 2048
    end
    
    create_table :wi_dates do |t|
      t.integer :event_id, :null => false
      t.date :value, :null => false
      t.integer :type, :null => false, :limit => 3
    end
    
    create_table :wi_calendar do |t|
      t.string :userid, :limit => 32, :null => false
      t.string :code, :limit => 10000, :null => false
    end
    
    create_table :wi_calendar_date, :id => false do |t|
      t.integer :calendar_id, :null => false
      t.integer :date_id, :null => false
    end
    
    create_table :wi_remove_event do |t|
      t.string :userid, :limit => 32, :null => false
      t.integer :event_id, :null => false
    end
    
    execute "ALTER TABLE wi_page_link ADD PRIMARY KEY (page_id, link_id)"
    execute "ALTER TABLE wi_calendar_date ADD PRIMARY KEY (calendar_id, date_id)"
  end
  
  def self.down
    drop_table :wi_pages
    drop_table :wi_links
    drop_table :wi_page_link
    drop_table :wi_feedback
    drop_table :wi_events
    drop_table :wi_dates
    drop_table :wi_calendar
    drop_table :wi_calendar_date
    drop_table :wi_remove_event
  end
  
end