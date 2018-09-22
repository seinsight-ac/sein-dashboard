class CreateGaDbs < ActiveRecord::Migration[5.1]
  def change
    create_table :ga_dbs do |t|
      t.datetime :date
      t.integer :web_users_day
      t.integer :web_users_week
      t.integer :web_users_month
      t.float :session_pageviews_day
      t.float :session_pageviews_week
      t.float :session_pageviews_month
      t.integer :users_day
      t.integer :users_week
      t.integer :users_month
      t.integer :sessions_day
      t.integer :sessions_week
      t.integer :sessions_month
      t.integer :active_users_day
      t.integer :active_users_week
      t.integer :active_users_month
      t.float :bouce_rate_day
      t.float :bouce_rate_week
      t.float :bouce_rate_month
      t.float :user_type_day
      t.float :user_type_week
      t.float :user_type_month
      t.integer :pageviews_day
      t.integer :pageviews_week
      t.integer :pageviews_month
      t.float :avg_session_duration_day
      t.float :avg_session_duration_week
      t.float :avg_session_duration_month
      t.float :avg_time_on_page_day
      t.float :avg_time_on_page_week
      t.float :avg_time_on_page_month
      t.float :pageviews_per_session_day
      t.float :pageviews_per_session_week
      t.float :pageviews_per_session_month
      t.integer :desktop_user
      t.integer :mobile_user
      t.integer :tablet_user
      t.integer :female_user
      t.integer :male_user
      t.integer :user_18_24
      t.integer :user_25_34
      t.integer :user_35_44
      t.integer :user_45_54
      t.integer :user_55_64
      t.integer :user_65
      t.integer :session_count_day
      t.integer :session_count_week
      t.integer :session_count_month
      t.integer :referral_user_day
      t.integer :referral_user_week
      t.integer :referral_user_month
      t.integer :direct_user_day
      t.integer :direct_user_week
      t.integer :direct_user_month
      t.integer :social_user_day
      t.integer :social_user_week
      t.integer :social_user_month
      t.integer :email_user_day
      t.integer :email_user_week
      t.integer :email_user_month
      t.integer :oganic_search_day
      t.integer :oganic_search_week
      t.integer :oganic_search_month

      t.timestamps
    end
  end
end
