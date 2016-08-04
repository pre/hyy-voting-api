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

ActiveRecord::Schema.define(version: 20160804084026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["code"], name: "index_departments_on_code", unique: true, using: :btree
  end

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
    t.index ["code"], name: "index_faculties_on_code", unique: true, using: :btree
  end

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
    t.index ["email"], name: "index_voters_on_email", using: :btree
    t.index ["ssn"], name: "index_voters_on_ssn", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "voter_id",     null: false
    t.integer  "candidate_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "election_id",  null: false
    t.index ["voter_id", "election_id"], name: "index_votes_on_voter_id_and_election_id", unique: true, using: :btree
  end

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
