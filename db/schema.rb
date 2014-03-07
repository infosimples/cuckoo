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

ActiveRecord::Schema.define(version: 20140307172800) do

  create_table "projects", force: true do |t|
    t.string "name"
  end

  create_table "tasks", force: true do |t|
    t.string "name"
  end

  create_table "time_entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "task_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "total_time"
    t.text     "description"
    t.boolean  "is_billable", default: false
  end

  add_index "time_entries", ["is_billable"], name: "index_time_entries_on_is_billable", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "time_zone"
    t.boolean  "is_active",                         default: true
    t.boolean  "subscriber_to_admin_summary_email", default: false
    t.boolean  "subscriber_to_user_summary_email",  default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["subscriber_to_admin_summary_email"], name: "index_users_on_subscriber_to_admin_summary_email", using: :btree
  add_index "users", ["subscriber_to_user_summary_email"], name: "index_users_on_subscriber_to_user_summary_email", using: :btree

end
