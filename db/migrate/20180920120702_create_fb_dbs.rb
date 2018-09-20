class CreateFbDbs < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_dbs do |t|
      t.datetime :date
      t.integer :fans
      t.integer :fans_adds_day
      t.integer :fans_losts_day
      t.integer :page_users_day
      t.integer :posts_users_day
      t.integer :fans_adds_week
      t.integer :fans_losts_week
      t.integer :page_users_week
      t.integer :posts_users_week
      t.integer :fans_adds_month
      t.integer :fans_losts_month
      t.integer :page_users_month
      t.integer :posts_users_month
      t.integer :post_enagements_day
      t.integer :post_users_day
      t.integer :negative_activity_day
      t.integer :negative_users_day
      t.integer :post_enagements_week
      t.integer :post_users_week
      t.integer :negative_activity_week
      t.integer :negative_users_week
      t.integer :post_enagements_month
      t.integer :post_users_month
      t.integer :negative_activity_month
      t.integer :negative_users_month
      t.integer :link_clicks_day
      t.integer :link_clicks_week
      t.integer :link_clicks_month
      t.integer :fans_female_day
      t.integer :fans_male_day
      t.integer :fans_13_17
      t.integer :fans_18_24
      t.integer :fans_25_34
      t.integer :fans_35_44
      t.integer :fans_45_54
      t.integer :fans_55_64
      t.integer :fans_65
      t.integer :page_impressions_day
      t.integer :post_impressions_day
      t.integer :page_impressions_week
      t.integer :post_impressions_week
      t.integer :page_impressions_month
      t.integer :post_impressions_month

      t.timestamps
    end
  end
end
