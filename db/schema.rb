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

ActiveRecord::Schema[7.2].define(version: 2025_07_07_071306) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.integer "street_number"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.integer "appartment"
    t.float "latitude"
    t.float "longitude"
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.integer "role"
    t.string "phone_number"
    t.boolean "is_active"
    t.boolean "is_read_only"
    t.boolean "is_account_owner"
    t.bigint "organization_id"
    t.string "first_name"
    t.string "last_name"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "pending_team_ids", array: true
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["invitation_token"], name: "index_administrators_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_administrators_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_administrators_on_invited_by"
    t.index ["jti"], name: "index_administrators_on_jti"
    t.index ["organization_id"], name: "index_administrators_on_organization_id"
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
  end

  create_table "administrators_teams", id: false, force: :cascade do |t|
    t.bigint "administrator_id", null: false
    t.bigint "team_id", null: false
    t.index ["administrator_id", "team_id"], name: "index_administrators_teams_on_administrator_id_and_team_id", unique: true
    t.index ["team_id", "administrator_id"], name: "index_administrators_teams_on_team_id_and_administrator_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "phone_number"
    t.integer "capacity"
    t.string "display_name"
    t.boolean "on_duty"
    t.datetime "delay_time"
    t.jsonb "analytics"
    t.bigint "organization_id"
    t.string "first_name"
    t.string "last_name"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "is_active"
    t.integer "pending_team_ids", array: true
    t.index ["email"], name: "index_drivers_on_email", unique: true
    t.index ["invitation_token"], name: "index_drivers_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_drivers_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_drivers_on_invited_by"
    t.index ["jti"], name: "index_drivers_on_jti"
    t.index ["organization_id"], name: "index_drivers_on_organization_id"
    t.index ["phone_number"], name: "index_drivers_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_drivers_on_reset_password_token", unique: true
  end

  create_table "drivers_teams", id: false, force: :cascade do |t|
    t.bigint "driver_id", null: false
    t.bigint "team_id", null: false
    t.index ["driver_id", "team_id"], name: "index_drivers_teams_on_driver_id_and_team_id", unique: true
    t.index ["team_id", "driver_id"], name: "index_drivers_teams_on_team_id_and_driver_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "task_id"
    t.index ["task_id"], name: "index_feedbacks_on_task_id"
  end

  create_table "hubs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "linked_tasks", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "linked_task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linked_task_id"], name: "index_linked_tasks_on_linked_task_id"
    t.index ["task_id"], name: "index_linked_tasks_on_task_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "country"
    t.string "timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "monthly_delivery_volume"
    t.integer "primary_industry"
    t.text "message"
    t.index ["email"], name: "index_organizations_on_email", unique: true
  end

  create_table "recipients", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "notes"
    t.boolean "skip_sms_notification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "date"
    t.bigint "driver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_schedules_on_driver_id"
  end

  create_table "subschedules", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.datetime "shift_start"
    t.datetime "shift_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_subschedules_on_schedule_id"
  end

  create_table "task_completion_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "short_id"
    t.datetime "complete_after"
    t.datetime "complete_before"
    t.datetime "eta"
    t.datetime "ect"
    t.datetime "delay_time"
    t.boolean "pickup_task"
    t.string "destination_notes"
    t.integer "quantity"
    t.datetime "service_time"
    t.string "tracking_url"
    t.jsonb "task_completion_requirements"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "driver_id"
    t.bigint "team_id"
    t.bigint "creator_id"
    t.bigint "recipient_id"
    t.index ["creator_id"], name: "index_tasks_on_creator_id"
    t.index ["driver_id"], name: "index_tasks_on_driver_id"
    t.index ["organization_id"], name: "index_tasks_on_organization_id"
    t.index ["recipient_id"], name: "index_tasks_on_recipient_id"
    t.index ["team_id"], name: "index_tasks_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.boolean "enable_self_assign"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "hub_id"
    t.index ["hub_id"], name: "index_teams_on_hub_id"
    t.index ["organization_id", "name"], name: "index_teams_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "license_plate"
    t.string "vehicle_type"
    t.string "color"
    t.string "description"
    t.bigint "drivers_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drivers_id"], name: "index_vehicles_on_drivers_id"
  end

  add_foreign_key "administrators", "organizations"
  add_foreign_key "drivers", "organizations"
  add_foreign_key "feedbacks", "tasks"
  add_foreign_key "linked_tasks", "tasks"
  add_foreign_key "linked_tasks", "tasks", column: "linked_task_id"
  add_foreign_key "schedules", "drivers"
  add_foreign_key "subschedules", "schedules"
  add_foreign_key "tasks", "administrators", column: "creator_id"
  add_foreign_key "tasks", "drivers"
  add_foreign_key "tasks", "organizations"
  add_foreign_key "tasks", "recipients"
  add_foreign_key "tasks", "teams"
  add_foreign_key "teams", "hubs"
  add_foreign_key "teams", "organizations"
  add_foreign_key "vehicles", "drivers", column: "drivers_id"
end
