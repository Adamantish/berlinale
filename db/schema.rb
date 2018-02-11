# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20180211155716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "requests", force: :cascade do |t|
    t.integer  "kind"
    t.integer  "movie_count"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "remote_ip"
  end

  add_index "requests", ["remote_ip"], name: "index_requests_on_remote_ip", using: :btree

  create_table "screenings", force: :cascade do |t|
    t.string   "title",         null: false
    t.string   "page_url"
    t.string   "image_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "html_row"
    t.string   "buy_url"
    t.string   "cinema"
    t.datetime "starts_at"
    t.string   "ticket_status"
  end

  add_index "screenings", ["ticket_status"], name: "index_screenings_on_ticket_status", using: :btree

end
