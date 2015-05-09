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

ActiveRecord::Schema.define(version: 20150507180220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avito_accounts", force: true do |t|
    t.string   "login"
    t.string   "pass"
    t.integer  "status",     default: 0,  null: false
    t.integer  "user_id",                 null: false
    t.json     "f",          default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "avito_accounts", ["login"], name: "index_avito_accounts_on_login", unique: true, using: :btree

  create_table "avito_finds", force: true do |t|
    t.json     "req"
    t.json     "res"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avito_postings", force: true do |t|
    t.string   "name",                                        null: false
    t.integer  "interval"
    t.boolean  "active"
    t.boolean  "allow_mail"
    t.json     "title"
    t.json     "description"
    t.json     "manager"
    t.json     "price"
    t.json     "images"
    t.json     "p"
    t.json     "e"
    t.integer  "count"
    t.integer  "user_id"
    t.datetime "next_at",     default: '2015-05-03 09:16:07'
    t.json     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "s",           default: {},                    null: false
  end

  add_index "avito_postings", ["user_id"], name: "index_avito_postings_on_user_id", using: :btree

  create_table "avito_tasklogs", id: false, force: true do |t|
    t.integer "i"
    t.integer "task_id"
    t.integer "module_id"
  end

  add_index "avito_tasklogs", ["i", "task_id", "module_id"], name: "index_avito_tasklogs_on_i_and_task_id_and_module_id", unique: true, using: :btree
  add_index "avito_tasklogs", ["task_id"], name: "index_avito_tasklogs_on_task_id", using: :btree

  create_table "avito_tasks", force: true do |t|
    t.string   "name"
    t.string   "stat"
    t.integer  "count",      default: 0
    t.integer  "interval"
    t.boolean  "active",     default: false
    t.integer  "counter"
    t.json     "p"
    t.json     "e"
    t.integer  "user_id"
    t.datetime "next_at",    default: '2015-05-03 09:16:07'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "avito_tasks", ["user_id"], name: "index_avito_tasks_on_user_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "name"
    t.string   "img_hash"
    t.string   "img_type"
    t.string   "img_class"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["img_hash", "user_id"], name: "index_images_on_img_hash_and_user_id", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role_id",                default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "antigate_key"
    t.integer  "antigate_money",         default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vk_accounts", force: true do |t|
    t.string   "login"
    t.string   "pass"
    t.string   "phone"
    t.boolean  "active"
    t.integer  "status"
    t.json     "info"
    t.integer  "user_id"
    t.integer  "proxy_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
