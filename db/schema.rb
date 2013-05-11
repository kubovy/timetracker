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

  create_table "companies", primary_key: "c_id", force: true do |t|
    t.string  "c_name",     limit: 200, default: "", null: false
    t.string  "c_www",      limit: 250
    t.string  "c_currency", limit: 7
    t.integer "c_locktime",             default: -1
  end

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
    t.integer  "team_id"
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

  add_index "projects", ["employer_id", "name"], name: "index_projects_on_employer_id_and_name", unique: true, using: :btree

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

  create_table "tt_client_project_binds", id: false, force: true do |t|
    t.integer "client_id",  null: false
    t.integer "project_id", null: false
  end

  create_table "tt_clients", force: true do |t|
    t.integer "team_id",                                  null: false
    t.string  "name",            limit: 80,               null: false
    t.string  "address"
    t.float   "tax",             limit: 6,  default: 0.0
    t.binary  "clnt_addr_your"
    t.string  "clnt_comment"
    t.text    "projects"
    t.integer "status",          limit: 1,  default: 1
    t.string  "clnt_fsubtotals", limit: 1
    t.float   "clnt_discount",   limit: 9,  default: 0.0, null: false
  end

  add_index "tt_clients", ["team_id", "name", "status"], name: "client_name_idx", unique: true, using: :btree

  create_table "tt_config", force: true do |t|
    t.integer "user_id",                null: false
    t.string  "param_name",  limit: 32, null: false
    t.string  "param_value", limit: 80
  end

  add_index "tt_config", ["user_id", "param_name"], name: "param_idx", unique: true, using: :btree

  create_table "tt_custom_field_log", force: true do |t|
    t.integer "log_id",    limit: 8, null: false
    t.integer "field_id",            null: false
    t.integer "option_id"
    t.string  "value"
  end

  create_table "tt_custom_field_options", force: true do |t|
    t.integer "field_id",                         null: false
    t.string  "value",    limit: 32, default: "", null: false
  end

  create_table "tt_custom_fields", force: true do |t|
    t.integer "team_id",                          null: false
    t.integer "type",     limit: 1,  default: 0,  null: false
    t.string  "label",    limit: 32, default: "", null: false
    t.integer "required", limit: 1,  default: 0
    t.integer "status",   limit: 1,  default: 1
  end

  create_table "tt_fav_reports", force: true do |t|
    t.string  "name",                limit: 200,                  null: false
    t.integer "user_id",                                          null: false
    t.integer "project_id"
    t.integer "task_id"
    t.text    "users"
    t.integer "period",              limit: 1
    t.date    "period_start"
    t.date    "period_end"
    t.integer "show_project",        limit: 1,   default: 0,      null: false
    t.integer "show_task",           limit: 1,   default: 0,      null: false
    t.integer "show_note",           limit: 1,   default: 0,      null: false
    t.integer "show_start",          limit: 1,   default: 0,      null: false
    t.integer "show_end",            limit: 1,   default: 0,      null: false
    t.integer "show_duration",       limit: 1,   default: 0,      null: false
    t.integer "show_cost",           limit: 1,   default: 0,      null: false
    t.integer "show_custom_field_1", limit: 1,   default: 0,      null: false
    t.integer "show_empty_days",     limit: 1,   default: 0,      null: false
    t.integer "show_totals_only",    limit: 1,   default: 0,      null: false
    t.string  "sort_by",             limit: 20,  default: "date"
    t.integer "billable",            limit: 1
  end

  create_table "tt_holidays", force: true do |t|
    t.date "date", null: false
  end

  add_index "tt_holidays", ["date"], name: "date_idx", unique: true, using: :btree

  create_table "tt_invoice_headers", primary_key: "user_id", force: true do |t|
    t.string  "number",       limit: 20
    t.string  "client_name"
    t.string  "client_addr"
    t.string  "comment"
    t.float   "tax",          limit: 6,  default: 0.0
    t.float   "discount",     limit: 6,  default: 0.0
    t.integer "subtotals",    limit: 1,  default: 0
    t.binary  "ih_addr_your"
    t.binary  "ih_addr_cust"
  end

  create_table "tt_invoices", force: true do |t|
    t.integer "team_id",                             null: false
    t.string  "name",       limit: 80,               null: false
    t.date    "date",                                null: false
    t.integer "client_id",                           null: false
    t.date    "start_date",                          null: false
    t.date    "end_date",                            null: false
    t.float   "discount",   limit: 6,  default: 0.0
  end

  add_index "tt_invoices", ["team_id", "name"], name: "name_idx", unique: true, using: :btree

  create_table "tt_log", force: true do |t|
    t.timestamp "timestamp",                        null: false
    t.integer   "user_id",                          null: false
    t.date      "date",                             null: false
    t.time      "start"
    t.time      "duration"
    t.integer   "client_id"
    t.integer   "project_id"
    t.integer   "task_id"
    t.integer   "invoice_id"
    t.binary    "comment"
    t.integer   "billable",   limit: 1, default: 0
  end

  add_index "tt_log", ["client_id"], name: "client_idx", using: :btree
  add_index "tt_log", ["date"], name: "date_idx", using: :btree
  add_index "tt_log", ["invoice_id"], name: "invoice_idx", using: :btree
  add_index "tt_log", ["project_id"], name: "project_idx", using: :btree
  add_index "tt_log", ["task_id"], name: "task_idx", using: :btree
  add_index "tt_log", ["user_id"], name: "user_idx", using: :btree

  create_table "tt_project_task_binds", force: true do |t|
    t.integer "project_id", null: false
    t.integer "task_id",    null: false
  end

  add_index "tt_project_task_binds", ["project_id"], name: "project_id", using: :btree
  add_index "tt_project_task_binds", ["task_id"], name: "task_id", using: :btree

  create_table "tt_projects", force: true do |t|
    t.integer   "team_id",                             null: false
    t.string    "name",         limit: 80
    t.timestamp "p_timestamp",                         null: false
    t.string    "description"
    t.text      "tasks"
    t.integer   "status",       limit: 1,  default: 1, null: false
    t.integer   "p_manager_id",            default: 0, null: false
    t.text      "p_activities"
  end

  add_index "tt_projects", ["team_id", "name", "status"], name: "project_idx", unique: true, using: :btree

  create_table "tt_tasks", force: true do |t|
    t.integer   "team_id",                              null: false
    t.string    "name",         limit: 200
    t.timestamp "a_timestamp",                          null: false
    t.string    "description"
    t.integer   "status",       limit: 1,   default: 1, null: false
    t.integer   "a_manager_id",             default: 0, null: false
  end

  add_index "tt_tasks", ["team_id", "name", "status"], name: "task_idx", unique: true, using: :btree

  create_table "tt_teams", force: true do |t|
    t.timestamp "timestamp",                                   null: false
    t.string    "name",        limit: 80
    t.string    "address"
    t.string    "currency",    limit: 7
    t.integer   "locktime",               default: 0
    t.string    "lang",        limit: 10, default: "en",       null: false
    t.string    "date_format", limit: 20, default: "%Y-%m-%d", null: false
    t.string    "time_format", limit: 20, default: "%H:%M",    null: false
    t.integer   "week_start",  limit: 2,  default: 0,          null: false
    t.string    "plugins"
    t.integer   "custom_logo", limit: 1,  default: 0
    t.integer   "status",      limit: 1,  default: 1
  end

  create_table "tt_timetable", force: true do |t|
    t.integer "user_id"
    t.boolean "day"
    t.time    "hours"
  end

  add_index "tt_timetable", ["user_id", "day"], name: "uniq_weekplan", unique: true, using: :btree

  create_table "tt_timetable_should", force: true do |t|
    t.integer "user_id", null: false
    t.date    "date",    null: false
    t.time    "hours",   null: false
  end

  add_index "tt_timetable_should", ["user_id", "date"], name: "timetable_should_uniq", unique: true, using: :btree

  create_table "tt_tmp_refs", id: false, force: true do |t|
    t.timestamp "timestamp",                         null: false
    t.string    "ref",       limit: 32, default: "", null: false
    t.integer   "user_id",              default: 0,  null: false
  end

  create_table "tt_user_project_binds", force: true do |t|
    t.integer "user_id",              default: 0,   null: false
    t.integer "project_id",           default: 0,   null: false
    t.float   "rate",       limit: 6, default: 0.0, null: false
    t.integer "status",     limit: 1, default: 1,   null: false
  end

  add_index "tt_user_project_binds", ["user_id", "project_id"], name: "bind_idx", unique: true, using: :btree

  create_table "tt_users", force: true do |t|
    t.timestamp "timestamp",                              null: false
    t.string    "login",        limit: 50
    t.string    "password",     limit: 50
    t.string    "name",         limit: 100
    t.integer   "team_id",                                null: false
    t.integer   "role",                     default: 4
    t.float     "rate",         limit: 6,   default: 0.0, null: false
    t.string    "email",        limit: 100
    t.integer   "status",       limit: 1,   default: 1,   null: false
    t.integer   "u_company_id"
    t.integer   "u_manager_id"
    t.integer   "u_level",      limit: 1,   default: 0,   null: false
    t.integer   "u_comanager",  limit: 1
    t.integer   "u_show_pie",   limit: 2,   default: 1
    t.integer   "u_pie_mode",   limit: 2,   default: 1
    t.string    "u_lang",       limit: 20
  end

  add_index "tt_users", ["login", "status"], name: "login_idx", unique: true, using: :btree

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
