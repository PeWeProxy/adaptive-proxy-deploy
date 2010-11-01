class AddWiPagesIndex < ActiveRecord::Migration
  def self.up
    add_index :wi_pages, :url
  end

  def self.down
    remove_index :wi_pages, :url
  end
end