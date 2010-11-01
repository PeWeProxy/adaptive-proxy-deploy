class ChangeCalendarCodeType < ActiveRecord::Migration
  def self.up
    change_table :wi_calendars do |t|
      t.change :code, :text, :limit => 4194304, :null => false
    end        
  end
  
  def self.down
    change_table :wi_calendars do |t|
      t.change :code, :string, :limit => 10000, :null => false
    end
  end
end