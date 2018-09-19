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

ActiveRecord::Schema.define(version: 20180919153109) do

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
