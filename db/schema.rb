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

ActiveRecord::Schema.define(version: 20130510122303) do

  create_table "employees", force: true do |t|
    t.integer  "user_id",                     null: false
    t.integer  "employer_id",                 null: false
    t.boolean  "is_manager",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employees", ["employer_id"], name: "index_employees_on_employer_id", using: :btree
  add_index "employees", ["user_id", "employer_id"], name: "index_employees_on_user_id_and_employer_id", unique: true, using: :btree
  add_index "employees", ["user_id"], name: "index_employees_on_user_id", using: :btree

  create_table "employers", force: true do |t|
    t.string   "name",                       null: false
    t.boolean  "is_deleted", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employers", ["name"], name: "index_employers_on_name", unique: true, using: :btree

  create_table "holidays", force: true do |t|
    t.integer  "employer_id", null: false
    t.date     "date",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holidays", ["employer_id", "date"], name: "index_holidays_on_employer_id_and_date", unique: true, using: :btree

  create_table "logs", force: true do |t|
    t.integer  "employer_id",                null: false
    t.integer  "team_id",                    null: false
    t.integer  "user_id",                    null: false
    t.integer  "client_id"
    t.integer  "invoice_id"
    t.integer  "project_id",                 null: false
    t.integer  "task_id",                    null: false
    t.date     "date",                       null: false
    t.time     "start",                      null: false
    t.time     "duration",                   null: false
    t.text     "description",                null: false
    t.boolean  "billable",    default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["billable"], name: "index_logs_on_billable", using: :btree
  add_index "logs", ["client_id"], name: "index_logs_on_client_id", using: :btree
  add_index "logs", ["date"], name: "index_logs_on_date", using: :btree
  add_index "logs", ["duration"], name: "index_logs_on_duration", using: :btree
  add_index "logs", ["employer_id"], name: "index_logs_on_employer_id", using: :btree
  add_index "logs", ["invoice_id"], name: "index_logs_on_invoice_id", using: :btree
  add_index "logs", ["project_id"], name: "index_logs_on_project_id", using: :btree
  add_index "logs", ["start"], name: "index_logs_on_start", using: :btree
  add_index "logs", ["task_id"], name: "index_logs_on_task_id", using: :btree
  add_index "logs", ["team_id"], name: "index_logs_on_team_id", using: :btree
  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "members", force: true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "employer_id",                 null: false
    t.string   "name",                        null: false
    t.string   "description",                 null: false
    t.integer  "owner_id",                    null: false
    t.boolean  "is_deleted",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["employer_id", "name"], name: "index_projects_on_name", unique: true, using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name",                        null: false
    t.string   "description"
    t.boolean  "is_deleted",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["name"], name: "index_tasks_on_name", unique: true, using: :btree

  create_table "teams", force: true do |t|
    t.integer  "employer_id",                 null: false
    t.string   "name",                        null: false
    t.boolean  "is_deleted",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["employer_id", "name"], name: "index_teams_on_employer_id_and_name", unique: true, using: :btree

  create_table "timetables", force: true do |t|
    t.integer  "employer_id", null: false
    t.integer  "employee_id", null: false
    t.integer  "day",         null: false
    t.time     "hours",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timetables", ["employer_id", "employee_id", "day"], name: "index_timetables_on_employer_id_and_employee_id_and_day", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                          null: false
    t.string   "email"
    t.boolean  "is_admin",       default: false, null: false
    t.boolean  "is_manager",     default: false, null: false
    t.string   "remember_token"
    t.boolean  "is_deleted",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
