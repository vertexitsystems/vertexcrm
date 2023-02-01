# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_05_131854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_managers", force: :cascade do |t|
    t.string "name"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "assistants", force: :cascade do |t|
    t.string "name"
    t.integer "profile_id"
    t.integer "account_manager_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "company_name"
    t.string "company_address"
    t.string "phone_number"
    t.string "fax_number"
    t.string "company_email"
    t.string "company_website"
    t.string "contact_name"
    t.string "contact_designation"
    t.string "contact_number"
    t.string "contact_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_types", force: :cascade do |t|
    t.integer "employer_id"
    t.integer "employee_id"
    t.integer "contract_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employees", force: :cascade do |t|
    t.integer "rate"
    t.integer "profile_id"
    t.integer "vendor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "passport"
    t.string "visa"
    t.string "state_id"
    t.string "i9"
    t.string "e_verify"
    t.string "w9"
    t.string "psa"
    t.string "voided_check_copy"
    t.integer "employer_id"
    t.integer "client_id"
    t.string "contract_type"
    t.string "visa_status"
    t.date "visa_expiry"
    t.boolean "disabled"
    t.string "disable_reason"
    t.date "disable_date"
    t.string "disable_notes"
    t.integer "job_id"
    t.integer "employer_rate"
    t.string "resume"
    t.string "new_hire_package"
    t.string "po"
    t.string "w2_contract"
    t.string "offer_letter"
    t.string "w4"
    t.string "direct_deposit_detail"
    t.string "emergency_contact_form"
    t.date "job_start_date"
    t.date "job_end_date"
    t.string "job_end_reason"
    t.decimal "employee_rate"
  end

  create_table "employers", force: :cascade do |t|
    t.string "company_name"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "company_address"
    t.string "phone_number"
    t.string "fax_number"
    t.string "company_email"
    t.string "company_website"
    t.string "contact_name"
    t.string "contact_designation"
    t.string "contact_number"
    t.string "contact_email"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_file"
    t.integer "employee_id"
    t.integer "employer_id"
    t.date "payment_date"
    t.boolean "payment_status", default: false, null: false
    t.string "payment_rejection_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "approval_status"
  end

  create_table "job_application_users", force: :cascade do |t|
    t.integer "job_application_id"
    t.integer "user_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.string "email"
    t.string "ph_no"
    t.text "cover_letter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_posts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "title"
    t.float "rate"
    t.text "job_description"
    t.string "location"
    t.integer "job_type"
    t.date "closing_date"
    t.string "closing_remarks"
    t.integer "vendor_id"
    t.integer "client_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "contract_type"
  end

  create_table "postings", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "employee_id"
    t.integer "job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "posting_rate"
    t.string "designation"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "full_name"
    t.integer "user_type"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.string "phone1"
    t.string "phone2"
    t.string "resume"
    t.string "degree"
    t.string "photo"
    t.string "cnic"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "vendor_id"
    t.integer "rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "vendor_rate"
  end

  create_table "timesheets", force: :cascade do |t|
    t.date "start_date"
    t.string "screen_shot"
    t.integer "monday", default: 0
    t.integer "tuesday", default: 0
    t.integer "wednesday", default: 0
    t.integer "thursday", default: 0
    t.integer "friday", default: 0
    t.integer "saturday", default: 0
    t.integer "sunday", default: 0
    t.integer "job_id"
    t.integer "employee_id"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_types", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "company_name"
    t.string "company_address"
    t.string "phone_number"
    t.string "fax_number"
    t.string "company_email"
    t.string "company_website"
    t.string "contact_name"
    t.string "contact_designation"
    t.string "contact_number"
    t.string "contact_email"
  end

  create_table "work_durations", force: :cascade do |t|
    t.integer "hours", default: 0
    t.date "work_day"
    t.integer "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "time_sheet_status", default: 0
    t.boolean "time_card_certify", default: false
    t.boolean "company_certify", default: false
    t.boolean "save_for_later", default: false
    t.string "timesheet_screenshot"
    t.string "rejection_message"
    t.boolean "status_read"
    t.integer "sun", default: -1
    t.integer "mon", default: -1
    t.integer "tue", default: -1
    t.integer "wed", default: -1
    t.integer "thu", default: -1
    t.integer "fri", default: -1
    t.integer "sat", default: -1
    t.string "contract_type"
    t.integer "employer_rate"
    t.integer "consultant_rate"
    t.integer "job_rate"
    t.integer "posting_id"
    t.integer "account_manager_id"
    t.integer "job_id"
    t.integer "employee_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
