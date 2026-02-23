# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_23_070731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "project_id", null: false
    t.string "session_key"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_conversations_on_project_id"
  end

  create_table "gateway_configs", force: :cascade do |t|
    t.text "api_token"
    t.datetime "created_at", null: false
    t.string "endpoint"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_gateway_configs_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.bigint "gateway_config_id"
    t.string "role"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["gateway_config_id"], name: "index_messages_on_gateway_config_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "repo_url"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "workspace_path"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "tool_calls", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.text "input"
    t.bigint "message_id"
    t.text "output"
    t.integer "status"
    t.string "tool_name"
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_tool_calls_on_conversation_id"
    t.index ["message_id"], name: "index_tool_calls_on_message_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "conversations", "projects"
  add_foreign_key "gateway_configs", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "gateway_configs"
  add_foreign_key "projects", "users"
  add_foreign_key "tool_calls", "conversations"
  add_foreign_key "tool_calls", "messages"
end
