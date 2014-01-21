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

ActiveRecord::Schema.define(version: 20140121202603) do

  create_table "cycles", force: true do |t|
    t.integer  "incident_id",                    null: false
    t.integer  "number",                         null: false
    t.integer  "current_object",                 null: false
    t.datetime "from",                           null: false
    t.datetime "to",                             null: false
    t.boolean  "closed",         default: false
    t.text     "priorities"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cycles", ["incident_id"], name: "index_cycles_on_incident_id", using: :btree

  create_table "incidents", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_expressions", force: true do |t|
    t.string   "hierarchical_path", null: false
    t.string   "text",              null: false
    t.integer  "cycle_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "text_expressions", ["cycle_id"], name: "index_text_expressions_on_cycle_id", using: :btree

end
