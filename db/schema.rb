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

ActiveRecord::Schema.define(version: 20141001150459) do

  create_table "repositories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "language"
    t.string   "owner"
    t.string   "homepage"
    t.boolean  "fork"
    t.date     "start_date"
    t.date     "update_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display",     default: false
  end

  add_index "repositories", ["user_id"], name: "index_repositories_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "login"
    t.string   "email"
    t.string   "avatar"
    t.string   "company"
    t.string   "location"
    t.string   "blog"
    t.string   "github_access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "websites", force: true do |t|
    t.string   "url"
    t.integer  "call_count"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "websites", ["user_id"], name: "index_websites_on_user_id"

end
