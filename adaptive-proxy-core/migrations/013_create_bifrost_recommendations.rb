class CreateBifrostRecommendations < ActiveRecord::Migration
  def self.up
    create_table :bf_recommendations do |t|
      t.string :userid, :limit => 32
      t.timestamp :timestamp
      t.string :original_query
      t.string :recommended_query
      t.string :recommended_url, :limit => 4000
      t.string :method, :limit => 50
    end
  end

  def self.down
    drop_table :bf_recommendations
  end
end
