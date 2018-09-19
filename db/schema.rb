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

ActiveRecord::Schema.define(version: 20180919101017) do

  create_table "alexa_dbs", force: :cascade do |t|
    t.integer "sein_rank"
    t.integer "newsmarket_rank"
    t.integer "pansci_rank"
    t.integer "einfo_rank"
    t.integer "npost_rank"
    t.integer "womany_rank"
    t.integer "sein_bounce_rate"
    t.integer "newsmarket_bounce_rate"
    t.integer "pansci_bounce_rate"
    t.integer "einfo_bounce_rate"
    t.integer "npost_bounce_rate"
    t.integer "womany_bounce_rate"
    t.integer "sein_pageview"
    t.integer "newsmarket_pageview"
    t.integer "pansci_pageview"
    t.integer "einfo_pageview"
    t.integer "npost_pageview"
    t.integer "womany_pageview"
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
    t.integer "open_rate"
    t.integer "click"
    t.integer "click_rate"
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
