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

ActiveRecord::Schema.define(version: 20150427133853) do

  create_table "answers", force: true do |t|
    t.text     "body"
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["ticket_id"], name: "index_answers_on_ticket_id"
  add_index "answers", ["user_id"], name: "index_answers_on_user_id"

  create_table "departments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enable",     default: true
  end

  create_table "owners", force: true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owners", ["ticket_id"], name: "index_owners_on_ticket_id"
  add_index "owners", ["user_id"], name: "index_owners_on_user_id"

  create_table "status_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", force: true do |t|
    t.integer  "status_type_id"
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["status_type_id"], name: "index_statuses_on_status_type_id"
  add_index "statuses", ["ticket_id"], name: "index_statuses_on_ticket_id"
  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id"

  create_table "tickets", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "department_id"
    t.string   "reference"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
  end

  add_index "tickets", ["department_id"], name: "index_tickets_on_department_id"
  add_index "tickets", ["reference"], name: "index_tickets_on_reference", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "admin",                  default: false
    t.boolean  "enable",                 default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
