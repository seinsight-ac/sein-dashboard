class RemoveColumnFromGaDb < ActiveRecord::Migration[5.1]
  def change
    remove_column :ga_dbs, :session_pageviews_week
    remove_column :ga_dbs, :session_pageviews_month
    remove_column :ga_dbs, :users_day
    remove_column :ga_dbs, :users_week
    remove_column :ga_dbs, :users_month
    remove_column :ga_dbs, :sessions_week
    remove_column :ga_dbs, :sessions_month
    remove_column :ga_dbs, :bounce_rate_week
    remove_column :ga_dbs, :bounce_rate_month
    remove_column :ga_dbs, :user_type_day
    remove_column :ga_dbs, :user_type_week
    remove_column :ga_dbs, :user_type_month
    remove_column :ga_dbs, :pageviews_week
    remove_column :ga_dbs, :pageviews_month
    remove_column :ga_dbs, :avg_session_duration_week
    remove_column :ga_dbs, :avg_session_duration_month
    remove_column :ga_dbs, :pageviews_per_session_week
    remove_column :ga_dbs, :pageviews_per_session_month
    remove_column :ga_dbs, :session_count_day
    remove_column :ga_dbs, :session_count_week
    remove_column :ga_dbs, :session_count_month
    remove_column :ga_dbs, :referral_user_week
    remove_column :ga_dbs, :referral_user_month
    remove_column :ga_dbs, :direct_user_week
    remove_column :ga_dbs, :direct_user_month
    remove_column :ga_dbs, :email_user_week
    remove_column :ga_dbs, :email_user_month
    remove_column :ga_dbs, :oganic_search_user_week
    remove_column :ga_dbs, :oganic_search_user_month
    add_column :ga_dbs, :direct_bounce, :float
    add_column :ga_dbs, :email_bounce, :float
    add_column :ga_dbs, :social_bounce, :float
    add_column :ga_dbs, :oganic_search_bounce, :float
    add_column :ga_dbs, :new_visitor, :integer
    add_column :ga_dbs, :return_visitor, :integer
  end
end
