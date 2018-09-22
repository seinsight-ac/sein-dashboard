class RemoveColumnFromFbDb < ActiveRecord::Migration[5.1]
  def change
    remove_column :fb_dbs, :post_users_day
    remove_column :fb_dbs, :post_users_week
    remove_column :fb_dbs, :post_users_month
    remove_column :fb_dbs, :negative_activity_day
    remove_column :fb_dbs, :negative_activity_week
    remove_column :fb_dbs, :negative_activity_month
    remove_column :fb_dbs, :page_impressions_day
    remove_column :fb_dbs, :page_impressions_week
    remove_column :fb_dbs, :page_impressions_month
    remove_column :fb_dbs, :post_impressions_day
    remove_column :fb_dbs, :post_impressions_week
    remove_column :fb_dbs, :post_impressions_month
    add_column :fb_dbs, :enagements_users_day, :integer
    add_column :fb_dbs, :enagements_users_week, :integer
    add_column :fb_dbs, :enagements_users_month, :integer
  end
end
