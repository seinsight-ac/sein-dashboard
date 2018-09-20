# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180920140423) do

  create_table "alexa_dbs", force: :cascade do |t|
    t.integer "sein_rank"
    t.integer "newsmarket_rank"
    t.integer "pansci_rank"
    t.integer "einfo_rank"
    t.integer "npost_rank"
    t.integer "womany_rank"
    t.float "sein_bounce_rate"
    t.float "newsmarket_bounce_rate"
    t.float "pansci_bounce_rate"
    t.float "einfo_bounce_rate"
    t.float "npost_bounce_rate"
    t.float "womany_bounce_rate"
    t.float "sein_pageview"
    t.float "newsmarket_pageview"
    t.float "pansci_pageview"
    t.float "einfo_pageview"
    t.float "npost_pageview"
    t.float "womany_pageview"
    t.integer "sein_on_site"
    t.integer "newsmarket_on_site"
    t.integer "pansci_on_site"
    t.integer "einfo_on_site"
    t.integer "npost_on_site"
    t.integer "womany_on_site"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fb_dbs", force: :cascade do |t|
    t.datetime "date"
    t.integer "fans"
    t.integer "fans_adds_day"
    t.integer "fans_losts_day"
    t.integer "page_users_day"
    t.integer "posts_users_day"
    t.integer "fans_adds_week"
    t.integer "fans_losts_week"
    t.integer "page_users_week"
    t.integer "posts_users_week"
    t.integer "fans_adds_month"
    t.integer "fans_losts_month"
    t.integer "page_users_month"
    t.integer "posts_users_month"
    t.integer "post_enagements_day"
    t.integer "post_users_day"
    t.integer "negative_activity_day"
    t.integer "negative_users_day"
    t.integer "post_enagements_week"
    t.integer "post_users_week"
    t.integer "negative_activity_week"
    t.integer "negative_users_week"
    t.integer "post_enagements_month"
    t.integer "post_users_month"
    t.integer "negative_activity_month"
    t.integer "negative_users_month"
    t.integer "link_clicks_day"
    t.integer "link_clicks_week"
    t.integer "link_clicks_month"
    t.integer "fans_female_day"
    t.integer "fans_male_day"
    t.integer "fans_13_17"
    t.integer "fans_18_24"
    t.integer "fans_25_34"
    t.integer "fans_35_44"
    t.integer "fans_45_54"
    t.integer "fans_55_64"
    t.integer "fans_65"
    t.integer "page_impressions_day"
    t.integer "post_impressions_day"
    t.integer "page_impressions_week"
    t.integer "post_impressions_week"
    t.integer "page_impressions_month"
    t.integer "post_impressions_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ga_dbs", force: :cascade do |t|
    t.datetime "date"
    t.integer "web_users_day"
    t.integer "web_users_week"
    t.integer "web_users_month"
    t.float "session_pageviews_day"
    t.float "session_pageviews_week"
    t.float "session_pageviews_month"
    t.integer "users_day"
    t.integer "users_week"
    t.integer "users_month"
    t.integer "sessions_day"
    t.integer "sessions_week"
    t.integer "sessions_month"
    t.integer "active_users_day"
    t.integer "active_users_week"
    t.integer "active_users_month"
    t.float "bouce_rate_day"
    t.float "bouce_rate_week"
    t.float "bouce_rate_month"
    t.float "user_type_day"
    t.float "user_type_week"
    t.float "user_type_month"
    t.integer "pageviews_day"
    t.integer "pageviews_week"
    t.integer "pageviews_month"
    t.float "avg_session_duration_day"
    t.float "avg_session_duration_week"
    t.float "avg_session_duration_month"
    t.float "avg_time_on_page_day"
    t.float "avg_time_on_page_week"
    t.float "avg_time_on_page_month"
    t.float "pageviews_per_session_day"
    t.float "pageviews_per_session_week"
    t.float "pageviews_per_session_month"
    t.integer "desktop_user"
    t.integer "mobile_user"
    t.integer "tablet_user"
    t.integer "female_user"
    t.integer "male_user"
    t.integer "user_18_24"
    t.integer "user_25_34"
    t.integer "user_35_44"
    t.integer "user_45_54"
    t.integer "user_55_64"
    t.integer "user_65"
    t.integer "session_count_day"
    t.integer "session_count_week"
    t.integer "session_count_month"
    t.integer "referral_user_day"
    t.integer "referral_user_week"
    t.integer "referral_user_month"
    t.integer "direct_user_day"
    t.integer "direct_user_week"
    t.integer "direct_user_month"
    t.integer "social_user_day"
    t.integer "social_user_week"
    t.integer "social_user_month"
    t.integer "email_user_day"
    t.integer "email_user_week"
    t.integer "email_user_month"
    t.integer "oganic_search_day"
    t.integer "oganic_search_week"
    t.integer "oganic_search_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailchimp_dbs", force: :cascade do |t|
    t.datetime "date"
    t.string "title"
    t.integer "email_sent"
    t.integer "open"
    t.float "open_rate"
    t.integer "click"
    t.float "click_rate"
    t.string "most_click_title"
    t.integer "most_click_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
