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

ActiveRecord::Schema[7.1].define(version: 2024_07_30_175020) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "document_type"
    t.binary "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document_id"], name: "index_bookmarks_on_document_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "cas_users", force: :cascade do |t|
    t.string "cas_directory_id"
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "user_type"
    t.index ["cas_directory_id"], name: "index_cas_users_on_cas_directory_id", unique: true
  end

  create_table "cas_users_groups", id: false, force: :cascade do |t|
    t.integer "cas_user_id"
    t.integer "group_id"
    t.index ["cas_user_id"], name: "index_cas_users_groups_on_cas_user_id"
    t.index ["group_id"], name: "index_cas_users_groups_on_group_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cron"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "download_urls", force: :cascade do |t|
    t.string "token"
    t.string "url"
    t.string "title"
    t.text "notes"
    t.string "mime_type"
    t.string "creator"
    t.boolean "enabled"
    t.string "request_ip"
    t.string "request_user_agent"
    t.datetime "accessed_at", precision: nil
    t.datetime "download_completed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "expires_at", precision: nil
    t.index ["token"], name: "index_download_urls_on_token", unique: true
  end

  create_table "export_job_requests", force: :cascade do |t|
    t.integer "export_job_id"
    t.boolean "validate_only"
    t.boolean "resume"
    t.string "job_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["export_job_id"], name: "index_export_job_requests_on_export_job_id"
  end

  create_table "export_jobs", force: :cascade do |t|
    t.string "format"
    t.integer "cas_user_id"
    t.datetime "timestamp", precision: nil
    t.string "name"
    t.integer "item_count"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "progress"
    t.boolean "export_binaries"
    t.bigint "binaries_size"
    t.integer "binaries_count"
    t.string "mime_types"
    t.integer "state"
    t.string "uris"
    t.index ["cas_user_id"], name: "index_export_jobs_on_cas_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "import_job_requests", force: :cascade do |t|
    t.integer "import_job_id"
    t.boolean "validate_only"
    t.boolean "resume"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "job_id"
    t.index ["import_job_id"], name: "index_import_job_requests_on_import_job_id"
  end

  create_table "import_jobs", force: :cascade do |t|
    t.integer "cas_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "timestamp", precision: nil
    t.string "name"
    t.integer "progress"
    t.string "model"
    t.string "access"
    t.string "collection"
    t.string "binaries_location"
    t.integer "binaries_count"
    t.integer "item_count"
    t.integer "state"
    t.index ["cas_user_id"], name: "index_import_jobs_on_cas_user_id"
  end

  create_table "public_keys", force: :cascade do |t|
    t.string "key"
    t.integer "cas_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cas_user_id"], name: "index_public_keys_on_cas_user_id"
  end

  create_table "publish_job_requests", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "publish_job_id"
    t.boolean "resume"
    t.string "job_id"
    t.index ["publish_job_id"], name: "index_publish_job_requests_on_publish_job_id"
  end

  create_table "publish_jobs", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "publish"
    t.text "solr_ids", default: "--- []\n"
    t.integer "cas_user_id"
    t.integer "state"
    t.string "name"
    t.boolean "force_hidden"
    t.integer "progress"
    t.index ["cas_user_id"], name: "index_publish_jobs_on_cas_user_id"
  end

  create_table "searches", force: :cascade do |t|
    t.binary "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "export_job_requests", "export_jobs"
  add_foreign_key "export_jobs", "cas_users"
  add_foreign_key "import_job_requests", "import_jobs"
  add_foreign_key "import_jobs", "cas_users"
  add_foreign_key "publish_job_requests", "publish_jobs"
  add_foreign_key "publish_jobs", "cas_users"
end
