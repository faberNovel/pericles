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

ActiveRecord::Schema.define(version: 2020_04_17_091346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_error_instances", id: :serial, force: :cascade do |t|
    t.string "name"
    t.json "body"
    t.integer "api_error_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_error_id"], name: "index_api_error_instances_on_api_error_id"
  end

  create_table "api_error_instances_mock_pickers", id: false, force: :cascade do |t|
    t.integer "api_error_instance_id", null: false
    t.integer "mock_picker_id", null: false
    t.index ["api_error_instance_id"], name: "index_api_error_instances_mock_pickers_on_api_error_instance_id"
    t.index ["mock_picker_id"], name: "index_api_error_instances_mock_pickers_on_mock_picker_id"
  end

  create_table "api_errors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.json "json_schema"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_api_errors_on_project_id"
  end

  create_table "api_gateway_integrations", force: :cascade do |t|
    t.string "title"
    t.string "uri_prefix"
    t.integer "timeout_in_millis"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_api_gateway_integrations_on_project_id"
  end

  create_table "attributes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_resource_id"
    t.boolean "is_array", default: false, null: false
    t.integer "primitive_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "enum"
    t.integer "minimum"
    t.integer "maximum"
    t.boolean "nullable", default: false, null: false
    t.integer "scheme_id"
    t.integer "min_items"
    t.integer "max_items"
    t.index ["parent_resource_id", "name"], name: "index_attributes_on_parent_resource_id_and_name", unique: true
    t.index ["resource_id"], name: "index_attributes_on_resource_id"
    t.index ["scheme_id"], name: "index_attributes_on_scheme_id"
  end

  create_table "attributes_resource_representations", id: :serial, force: :cascade do |t|
    t.boolean "is_required", default: false, null: false
    t.integer "parent_resource_representation_id"
    t.integer "attribute_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_representation_id"
    t.boolean "is_null", default: false, null: false
    t.string "custom_key_name"
    t.index ["attribute_id"], name: "index_attributes_resource_representations_on_attribute_id"
    t.index ["parent_resource_representation_id"], name: "index_arr_on_parent_resource_representation_id"
    t.index ["resource_representation_id"], name: "index_arr_on_resource_representation_id"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.bigint "project_id"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["project_id"], name: "index_audits_on_project_id"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "headers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "http_message_type"
    t.integer "http_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["http_message_type", "http_message_id"], name: "index_headers_on_http_message_type_and_http_message_id"
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_members_on_project_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "metadata", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "primitive_type", default: 0
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "nullable", default: true, null: false
    t.index ["project_id"], name: "index_metadata_on_project_id"
  end

  create_table "metadata_responses", id: :serial, force: :cascade do |t|
    t.integer "metadatum_id"
    t.integer "response_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key", default: "", null: false
    t.boolean "required", default: false
    t.index ["metadatum_id"], name: "index_metadata_responses_on_metadatum_id"
    t.index ["response_id"], name: "index_metadata_responses_on_response_id"
  end

  create_table "metadatum_instances", id: :serial, force: :cascade do |t|
    t.string "name"
    t.json "body"
    t.integer "metadatum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metadatum_id"], name: "index_metadatum_instances_on_metadatum_id"
  end

  create_table "metadatum_instances_mock_pickers", id: false, force: :cascade do |t|
    t.bigint "metadatum_instance_id", null: false
    t.bigint "mock_picker_id", null: false
  end

  create_table "mock_pickers", id: :serial, force: :cascade do |t|
    t.integer "mock_profile_id"
    t.integer "response_id"
    t.string "url_pattern"
    t.string "body_pattern"
    t.integer "instances_number"
    t.integer "priority", default: 0, null: false
    t.index ["mock_profile_id"], name: "index_mock_pickers_on_mock_profile_id"
    t.index ["response_id"], name: "index_mock_pickers_on_response_id"
  end

  create_table "mock_pickers_resource_instances", id: false, force: :cascade do |t|
    t.integer "resource_instance_id", null: false
    t.integer "mock_picker_id", null: false
    t.index ["mock_picker_id"], name: "index_mock_pickers_resource_instances_on_mock_picker_id"
    t.index ["resource_instance_id"], name: "index_mock_pickers_resource_instances_on_resource_instance_id"
  end

  create_table "mock_profiles", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_mock_profiles_on_ancestry"
    t.index ["project_id"], name: "index_mock_profiles_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mock_profile_id"
    t.boolean "is_public", default: false, null: false
    t.string "slack_incoming_webhook_url"
    t.string "slack_channel"
    t.datetime "slack_updated_at"
    t.index ["mock_profile_id"], name: "index_projects_on_mock_profile_id"
  end

  create_table "proxy_configurations", force: :cascade do |t|
    t.bigint "project_id"
    t.string "target_base_url", null: false
    t.string "proxy_hostname"
    t.integer "proxy_port"
    t.string "proxy_username"
    t.string "proxy_password"
    t.boolean "ignore_ssl", default: false, null: false
    t.index ["project_id"], name: "index_proxy_configurations_on_project_id"
  end

  create_table "query_parameters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "primitive_type"
    t.boolean "is_optional", default: true, null: false
    t.integer "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_id"], name: "index_query_parameters_on_route_id"
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.integer "response_status_code"
    t.string "response_body"
    t.json "response_headers"
    t.string "request_body"
    t.json "request_headers"
    t.string "request_method"
    t.string "url"
    t.integer "route_id"
    t.integer "response_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "validated", default: true
    t.index ["project_id"], name: "index_reports_on_project_id"
    t.index ["response_id"], name: "index_reports_on_response_id"
    t.index ["route_id"], name: "index_reports_on_route_id"
  end

  create_table "resource_instances", id: :serial, force: :cascade do |t|
    t.string "name"
    t.json "body"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_resource_instances_on_resource_id"
  end

  create_table "resource_representations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_resource_representations_on_resource_id"
  end

  create_table "resources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_resources_on_project_id"
  end

  create_table "responses", id: :serial, force: :cascade do |t|
    t.integer "status_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "route_id"
    t.integer "resource_representation_id"
    t.boolean "is_collection", default: false, null: false
    t.string "root_key"
    t.integer "api_error_id"
    t.index ["api_error_id"], name: "index_responses_on_api_error_id"
    t.index ["resource_representation_id"], name: "index_responses_on_resource_representation_id"
    t.index ["route_id"], name: "index_responses_on_route_id"
  end

  create_table "routes", id: :serial, force: :cascade do |t|
    t.text "description"
    t.integer "http_method"
    t.string "url"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "request_resource_representation_id"
    t.boolean "request_is_collection", default: false, null: false
    t.string "request_root_key"
    t.bigint "security_scheme_id"
    t.string "deprecated"
    t.string "operation_id"
    t.index ["request_resource_representation_id"], name: "index_routes_on_request_resource_representation_id"
    t.index ["resource_id"], name: "index_routes_on_resource_id"
    t.index ["security_scheme_id"], name: "index_routes_on_security_scheme_id"
  end

  create_table "schemes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "regexp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "security_schemes", force: :cascade do |t|
    t.string "key"
    t.string "security_scheme_type"
    t.string "name"
    t.string "security_scheme_in"
    t.bigint "project_id"
    t.jsonb "specification_extensions", default: {}
    t.string "description"
    t.string "scheme"
    t.string "bearer_format"
    t.jsonb "flows", default: {}
    t.string "open_id_connect_url"
    t.index ["project_id"], name: "index_security_schemes_on_project_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "avatar_url"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "internal", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "validation_errors", id: :serial, force: :cascade do |t|
    t.integer "category"
    t.text "description"
    t.integer "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_validation_errors_on_report_id"
  end

  create_table "validations", id: :serial, force: :cascade do |t|
    t.json "json_schema"
    t.json "json_instance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "api_error_instances", "api_errors"
  add_foreign_key "api_gateway_integrations", "projects"
  add_foreign_key "attributes", "resources"
  add_foreign_key "attributes", "resources", column: "parent_resource_id"
  add_foreign_key "attributes", "schemes"
  add_foreign_key "attributes_resource_representations", "attributes"
  add_foreign_key "attributes_resource_representations", "resource_representations"
  add_foreign_key "attributes_resource_representations", "resource_representations", column: "parent_resource_representation_id"
  add_foreign_key "audits", "projects"
  add_foreign_key "members", "projects"
  add_foreign_key "members", "users"
  add_foreign_key "metadata", "projects"
  add_foreign_key "metadata_responses", "metadata"
  add_foreign_key "metadata_responses", "responses"
  add_foreign_key "metadatum_instances", "metadata"
  add_foreign_key "mock_pickers", "mock_profiles"
  add_foreign_key "mock_pickers", "responses"
  add_foreign_key "projects", "mock_profiles"
  add_foreign_key "proxy_configurations", "projects"
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
  add_foreign_key "security_schemes", "projects"
  add_foreign_key "validation_errors", "reports"
end
