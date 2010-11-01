class CreateBifrostRecommendationGroups < ActiveRecord::Migration
  def self.up
    create_table :bf_recommendation_groups do |t|
      t.string :userid, :limit => 32
      t.timestamp :timestamp
      t.string :original_query
    end

    remove_column :bf_recommendations, :userid
    remove_column :bf_recommendations, :timestamp
    remove_column :bf_recommendations, :original_query
  end

  def self.down
    drop_table :bf_recommendation_groups

    add_column :bf_recommendations, :userid, :string, :limit => 32
    add_column :bf_recommendations, :timestamp, :timestamp
    add_column :bf_recommendations, :original_query, :string
  end
end
