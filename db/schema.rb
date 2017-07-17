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

ActiveRecord::Schema.define(version: 20170620142209) do

  create_table "keyword_pools", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_input_count"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "notice_keywords", force: :cascade do |t|
    t.string   "name"
    t.boolean  "status"
    t.integer  "noticetitle_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "notice_keywords_user_keywords", id: false, force: :cascade do |t|
    t.integer  "user_keyword_id",   null: false
    t.integer  "notice_keyword_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "notice_keywords_user_keywords", ["notice_keyword_id", "user_keyword_id"], name: "user_keyword_notice_join"
  add_index "notice_keywords_user_keywords", ["user_keyword_id", "notice_keyword_id"], name: "user_notice_keyword_join"

  create_table "noticetitles", force: :cascade do |t|
    t.integer  "category"
    t.string   "title"
    t.string   "link"
    t.string   "upload_date"
    t.text     "contents"
    t.string   "img"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "standard_keywords", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_keywords", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "link"
    t.boolean  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_mail_statuses", force: :cascade do |t|
    t.boolean  "status"
    t.string   "user_name"
    t.string   "users_id"
    t.string   "keyword_name"
    t.string   "user_keywords_id"
    t.string   "link"
    t.string   "noticetitles_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "user_name"
    t.string   "major"
    t.string   "student_number"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
