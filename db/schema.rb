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

ActiveRecord::Schema.define(version: 20151102102733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "alliances", force: :cascade do |t|
    t.string   "name",            null: false
    t.integer  "election_id",     null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "faculty_id"
    t.integer  "department_id"
    t.integer  "numbering_order"
  end

  create_table "candidates", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "alliance_id",      null: false
    t.string   "firstname",        null: false
    t.string   "lastname",         null: false
    t.string   "spare_firstname",  null: false
    t.string   "spare_lastname",   null: false
    t.string   "ssn"
    t.integer  "candidate_number"
    t.integer  "numbering_order"
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "code",       null: false
    t.integer  "faculty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "departments", ["code"], name: "index_departments_on_code", unique: true, using: :btree

  create_table "elections", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "faculty_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "department_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "faculties", ["code"], name: "index_faculties_on_code", unique: true, using: :btree

  create_table "voters", force: :cascade do |t|
    t.string   "name",              null: false
    t.string   "email"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "faculty_id",        null: false
    t.string   "ssn",               null: false
    t.string   "student_number"
    t.integer  "start_year"
    t.integer  "extent_of_studies"
    t.string   "phone"
    t.integer  "department_id"
  end

  add_index "voters", ["email"], name: "index_voters_on_email", using: :btree
  add_index "voters", ["ssn"], name: "index_voters_on_ssn", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "voter_id",     null: false
    t.integer  "candidate_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "election_id",  null: false
  end

  add_index "votes", ["voter_id", "election_id"], name: "index_votes_on_voter_id_and_election_id", unique: true, using: :btree

  add_foreign_key "alliances", "departments"
  add_foreign_key "alliances", "elections"
  add_foreign_key "alliances", "faculties"
  add_foreign_key "candidates", "alliances"
  add_foreign_key "departments", "faculties"
  add_foreign_key "elections", "departments"
  add_foreign_key "elections", "faculties"
  add_foreign_key "voters", "departments"
  add_foreign_key "voters", "faculties"
  add_foreign_key "votes", "candidates"
  add_foreign_key "votes", "elections"
  add_foreign_key "votes", "voters"
end
