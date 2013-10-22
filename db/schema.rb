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

ActiveRecord::Schema.define(version: 20131022110225) do

  create_table "companies", force: true do |t|
    t.integer  "vat"
    t.string   "name"
    t.string   "district"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_type_id"
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree
  add_index "companies", ["vat"], name: "index_companies_on_vat", unique: true, using: :btree

  create_table "contracts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "job_position_id"
  end

  add_index "contracts", ["company_id", "employee_id"], name: "index_contracts_on_company_id_and_employee_id", unique: true, using: :btree

  create_table "employees", force: true do |t|
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_positions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_positions", ["name"], name: "index_job_positions_on_name", unique: true, using: :btree

  create_table "payments", force: true do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "employee_id"
  end

  add_index "payments", ["company_id", "employee_id", "year", "month"], name: "unique_fields", unique: true, using: :btree

  create_table "property_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_types", ["name"], name: "index_property_types_on_name", unique: true, using: :btree

  create_table "transfers", force: true do |t|
    t.date     "transfer_date"
    t.integer  "amount"
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
