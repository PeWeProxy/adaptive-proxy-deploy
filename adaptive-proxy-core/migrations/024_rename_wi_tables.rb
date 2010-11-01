class RenameWiTables < ActiveRecord::Migration
  def self.up    
    rename_table :wi_calendar, :wi_calendars
    rename_table :wi_calendar_date, :wi_calendar_dates
    rename_table :wi_feedback, :wi_feedbacks
    rename_table :wi_interest, :wi_interests
  end
  
  def self.down
    rename_table :wi_calendars, :wi_calendar
    rename_table :wi_calendar_dates, :wi_calendar_date
    rename_table :wi_feedbacks, :wi_feedback
    rename_table :wi_interests, :wi_interest
  end
end