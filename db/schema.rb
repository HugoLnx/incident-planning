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

ActiveRecord::Schema.define(version: 20141006181832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approvals", force: true do |t|
    t.integer  "expression_id"
    t.string   "expression_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "positive",        null: false
    t.integer  "user_id",         null: false
    t.integer  "role_id",         null: false
  end

  add_index "approvals", ["expression_id"], name: "index_approvals_on_expression_id", using: :btree
  add_index "approvals", ["expression_type"], name: "index_approvals_on_expression_type", using: :btree
  add_index "approvals", ["role_id"], name: "index_approvals_on_role_id", using: :btree
  add_index "approvals", ["user_id"], name: "index_approvals_on_user_id", using: :btree

  create_table "cycles", force: true do |t|
    t.integer  "incident_id",                                null: false
    t.integer  "number",                                     null: false
    t.integer  "current_object",                             null: false
    t.datetime "from",                                       null: false
    t.datetime "to",                                         null: false
    t.boolean  "closed",                     default: false
    t.text     "priorities"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "priorities_approval_status", default: false, null: false
  end

  add_index "cycles", ["incident_id"], name: "index_cycles_on_incident_id", using: :btree

  create_table "features_configs", force: true do |t|
    t.integer "user_id"
    t.boolean "thesis_tools", default: true, null: false
  end

  add_index "features_configs", ["user_id"], name: "index_features_configs_on_user_id", using: :hash

  create_table "groups", force: true do |t|
    t.string   "name",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "father_id"
    t.integer  "cycle_id",    null: false
    t.string   "criticality"
  end

  add_index "groups", ["cycle_id"], name: "index_groups_on_cycle_id", using: :btree
  add_index "groups", ["father_id"], name: "index_groups_on_father_id", using: :btree

  create_table "incidents", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reuse_configurations", force: true do |t|
    t.boolean "hierarchy",             default: true
    t.string  "user_filter_type",      default: "all", null: false
    t.string  "user_filter_value"
    t.string  "incident_filter_type",  default: "all", null: false
    t.string  "incident_filter_value"
    t.integer "user_id",                               null: false
    t.integer "date_filter"
    t.boolean "enabled",               default: true
  end

  add_index "reuse_configurations", ["user_id"], name: "index_reuse_configurations_on_user_id", using: :hash

  create_table "text_expressions", force: true do |t|
    t.string   "name",                       null: false
    t.string   "text",                       null: false
    t.integer  "cycle_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "owner_id"
    t.string   "source"
    t.boolean  "reused",     default: false, null: false
  end

  add_index "text_expressions", ["cycle_id"], name: "index_text_expressions_on_cycle_id", using: :btree
  add_index "text_expressions", ["group_id"], name: "index_text_expressions_on_group_id", using: :btree
  add_index "text_expressions", ["owner_id"], name: "index_text_expressions_on_owner_id", using: :btree

  create_table "time_expressions", force: true do |t|
    t.datetime "when"
    t.string   "name",                       null: false
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cycle_id"
    t.integer  "owner_id"
    t.string   "text"
    t.string   "source"
    t.boolean  "reused",     default: false, null: false
  end

  add_index "time_expressions", ["cycle_id"], name: "index_time_expressions_on_cycle_id", using: :btree
  add_index "time_expressions", ["group_id"], name: "index_time_expressions_on_group_id", using: :btree
  add_index "time_expressions", ["owner_id"], name: "index_time_expressions_on_owner_id", using: :btree

  create_table "url_tracks", force: true do |t|
    t.integer  "session_id"
    t.string   "track_type"
    t.string   "url"
    t.datetime "datetime"
  end

  add_index "url_tracks", ["session_id"], name: "index_url_tracks_on_session_id", using: :btree
  add_index "url_tracks", ["track_type"], name: "index_url_tracks_on_track_type", using: :btree

  create_table "user_roles", force: true do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "phone",                  limit: 25
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.integer  "number"
    t.integer  "cycle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "ics234_pdf", null: false
    t.binary   "ics202_pdf", null: false
    t.integer  "user_id"
  end

  add_index "versions", ["cycle_id"], name: "index_versions_on_cycle_id", using: :hash
  add_index "versions", ["user_id"], name: "index_versions_on_user_id", using: :hash

end
