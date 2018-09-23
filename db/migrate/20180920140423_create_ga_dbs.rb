class CreateGaDbs < ActiveRecord::Migration[5.1]
  def change
    create_table :ga_dbs do |t|
      t.datetime :date
      t.integer :web_users_day
      t.integer :web_users_week
      t.integer :web_users_month
      t.float :session_pageviews_day
      t.integer :sessions_day
      t.float :bouce_rate_day
      t.integer :pageviews_day
      t.float :avg_session_duration_day
      t.float :avg_time_on_page_day
      t.float :pageviews_per_session_day
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
      t.integer :referral_user_day
      t.integer :direct_user_day
      t.integer :social_user_day
      t.integer :email_user_day
      t.integer :oganic_search_day
      t.float :direct_bounce
      t.float :email_bounce
      t.float :social_bounce
      t.float :oganic_search_bounce
      t.integer :new_visitor
      t.integer :return_visitor
      t.float :referral_bounce

      t.timestamps
    end
  end
end
