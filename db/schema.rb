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

ActiveRecord::Schema.define(version: 20171229133209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_error_instances", force: :cascade do |t|
    t.string   "name"
    t.json     "body"
    t.integer  "api_error_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["api_error_id"], name: "index_api_error_instances_on_api_error_id", using: :btree
  end

  create_table "api_error_instances_mock_pickers", id: false, force: :cascade do |t|
    t.integer "api_error_instance_id", null: false
    t.integer "mock_picker_id",        null: false
    t.index ["api_error_instance_id"], name: "index_api_error_instances_mock_pickers_on_api_error_instance_id", using: :btree
    t.index ["mock_picker_id"], name: "index_api_error_instances_mock_pickers_on_mock_picker_id", using: :btree
  end

  create_table "api_errors", force: :cascade do |t|
    t.string   "name"
    t.json     "json_schema"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["project_id"], name: "index_api_errors_on_project_id", using: :btree
  end

  create_table "attribute_fakers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attributes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_resource_id"
    t.boolean  "is_array",           default: false, null: false
    t.integer  "primitive_type"
    t.integer  "resource_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "enum"
    t.integer  "minimum"
    t.integer  "maximum"
    t.boolean  "nullable",           default: false, null: false
    t.integer  "faker_id"
    t.integer  "scheme_id"
    t.integer  "min_items"
    t.integer  "max_items"
    t.index ["faker_id"], name: "index_attributes_on_faker_id", using: :btree
    t.index ["resource_id"], name: "index_attributes_on_resource_id", using: :btree
    t.index ["scheme_id"], name: "index_attributes_on_scheme_id", using: :btree
  end

  create_table "attributes_resource_representations", force: :cascade do |t|
    t.boolean  "is_required",                       default: false, null: false
    t.integer  "parent_resource_representation_id"
    t.integer  "attribute_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "resource_representation_id"
    t.boolean  "is_null",                           default: false, null: false
    t.string   "custom_key_name"
    t.index ["attribute_id"], name: "index_attributes_resource_representations_on_attribute_id", using: :btree
    t.index ["parent_resource_representation_id"], name: "index_arr_on_parent_resource_representation_id", using: :btree
    t.index ["resource_representation_id"], name: "index_arr_on_resource_representation_id", using: :btree
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index", using: :btree
    t.index ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
    t.index ["created_at"], name: "index_audits_on_created_at", using: :btree
    t.index ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
    t.index ["user_id", "user_type"], name: "user_index", using: :btree
  end

  create_table "headers", force: :cascade do |t|
    t.string   "name"
    t.string   "http_message_type"
    t.integer  "http_message_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "value"
    t.index ["http_message_type", "http_message_id"], name: "index_headers_on_http_message_type_and_http_message_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_members_on_project_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "mock_pickers", force: :cascade do |t|
    t.integer "mock_profile_id"
    t.integer "response_id"
    t.string  "url_pattern"
    t.string  "body_pattern"
    t.index ["mock_profile_id"], name: "index_mock_pickers_on_mock_profile_id", using: :btree
    t.index ["response_id"], name: "index_mock_pickers_on_response_id", using: :btree
  end

  create_table "mock_pickers_resource_instances", id: false, force: :cascade do |t|
    t.integer "resource_instance_id", null: false
    t.integer "mock_picker_id",       null: false
    t.index ["mock_picker_id"], name: "index_mock_pickers_resource_instances_on_mock_picker_id", using: :btree
    t.index ["resource_instance_id"], name: "index_mock_pickers_resource_instances_on_resource_instance_id", using: :btree
  end

  create_table "mock_profiles", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
    t.index ["ancestry"], name: "index_mock_profiles_on_ancestry", using: :btree
    t.index ["project_id"], name: "index_mock_profiles_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "proxy_url"
    t.integer  "mock_profile_id"
    t.index ["mock_profile_id"], name: "index_projects_on_mock_profile_id", using: :btree
  end

  create_table "query_parameters", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "primitive_type"
    t.boolean  "is_optional",    default: true, null: false
    t.integer  "route_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["route_id"], name: "index_query_parameters_on_route_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "response_status_code"
    t.string   "response_body"
    t.json     "response_headers"
    t.string   "request_body"
    t.json     "request_headers"
    t.string   "request_method"
    t.string   "url"
    t.integer  "route_id"
    t.integer  "response_id"
    t.integer  "project_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["project_id"], name: "index_reports_on_project_id", using: :btree
    t.index ["response_id"], name: "index_reports_on_response_id", using: :btree
    t.index ["route_id"], name: "index_reports_on_route_id", using: :btree
  end

  create_table "resource_instances", force: :cascade do |t|
    t.string   "name"
    t.json     "body"
    t.integer  "resource_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["resource_id"], name: "index_resource_instances_on_resource_id", using: :btree
  end

  create_table "resource_representations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "resource_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["resource_id"], name: "index_resource_representations_on_resource_id", using: :btree
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["project_id"], name: "index_resources_on_project_id", using: :btree
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "status_code"
    t.json     "body_schema_backup"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "route_id"
    t.integer  "resource_representation_id"
    t.boolean  "is_collection",              default: false, null: false
    t.string   "root_key"
    t.integer  "api_error_id"
    t.index ["api_error_id"], name: "index_responses_on_api_error_id", using: :btree
    t.index ["resource_representation_id"], name: "index_responses_on_resource_representation_id", using: :btree
    t.index ["route_id"], name: "index_responses_on_route_id", using: :btree
  end

  create_table "routes", force: :cascade do |t|
    t.text     "description"
    t.integer  "http_method"
    t.string   "url"
    t.integer  "resource_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.json     "request_body_schema_backup"
    t.integer  "request_resource_representation_id"
    t.boolean  "request_is_collection",              default: false, null: false
    t.string   "request_root_key"
    t.index ["request_resource_representation_id"], name: "index_routes_on_request_resource_representation_id", using: :btree
    t.index ["resource_id"], name: "index_routes_on_resource_id", using: :btree
  end

  create_table "schemes", force: :cascade do |t|
    t.string   "name"
    t.string   "regexp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_url"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "validation_errors", force: :cascade do |t|
    t.integer  "category"
    t.string   "description"
    t.integer  "report_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["report_id"], name: "index_validation_errors_on_report_id", using: :btree
  end

  create_table "validations", force: :cascade do |t|
    t.json     "json_schema"
    t.json     "json_instance"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "api_error_instances", "api_errors"
  add_foreign_key "attributes", "attribute_fakers", column: "faker_id"
  add_foreign_key "attributes", "resources"
  add_foreign_key "attributes", "resources", column: "parent_resource_id"
  add_foreign_key "attributes", "schemes"
  add_foreign_key "attributes_resource_representations", "attributes"
  add_foreign_key "attributes_resource_representations", "resource_representations"
  add_foreign_key "attributes_resource_representations", "resource_representations", column: "parent_resource_representation_id"
  add_foreign_key "members", "projects"
  add_foreign_key "members", "users"
  add_foreign_key "mock_pickers", "mock_profiles"
  add_foreign_key "mock_pickers", "responses"
  add_foreign_key "projects", "mock_profiles"
  add_foreign_key "query_parameters", "routes"
  add_foreign_key "reports", "projects"
  add_foreign_key "reports", "responses"
  add_foreign_key "reports", "routes"
  add_foreign_key "resource_instances", "resources"
  add_foreign_key "resource_representations", "resources"
  add_foreign_key "resources", "projects"
  add_foreign_key "responses", "api_errors"
  add_foreign_key "responses", "resource_representations"
  add_foreign_key "responses", "routes"
  add_foreign_key "routes", "resource_representations", column: "request_resource_representation_id"
  add_foreign_key "routes", "resources"
  add_foreign_key "validation_errors", "reports"
end
