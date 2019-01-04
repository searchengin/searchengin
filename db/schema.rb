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

ActiveRecord::Schema.define(version: 2019_01_04_114856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alias_tags", force: :cascade do |t|
    t.text "url"
    t.string "code"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "count", default: 0
    t.integer "order_number", default: 9999
    t.text "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dislikes", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "user_id"
    t.bigint "url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_dislikes_on_tag_id"
    t.index ["url_id"], name: "index_dislikes_on_url_id"
    t.index ["user_id"], name: "index_dislikes_on_user_id"
  end

  create_table "domains", force: :cascade do |t|
    t.text "domain"
    t.integer "points", default: 0
    t.integer "average", default: 0
    t.integer "urls_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "user_id"
    t.bigint "url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_likes_on_tag_id"
    t.index ["url_id"], name: "index_likes_on_url_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "photo_data", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.integer "postphoto_id"
    t.boolean "verified"
    t.datetime "verified_time"
    t.integer "verified_user_id"
    t.string "is_bot"
    t.boolean "rejected"
    t.string "rejected_comment"
    t.datetime "rejected_time"
    t.integer "rejected_user_id"
    t.string "rejected_cancel_comment"
    t.datetime "rejected_cancel_time"
    t.integer "rejected_cancel_user_id"
    t.integer "points"
    t.string "url"
    t.string "photo_url"
    t.string "text"
    t.integer "photo_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "kind"
    t.string "name"
    t.string "username"
    t.string "postphoto_id"
    t.boolean "verified", default: false
    t.time "verified_time"
    t.integer "verified_user_id"
    t.boolean "is_bot", default: false
    t.boolean "rejected", default: false
    t.text "rejected_comment"
    t.time "rejected_time"
    t.integer "rejected_user_id"
    t.text "rejected_cancel_comment"
    t.time "rejected_cancel_time"
    t.integer "rejected_cancel_user_id"
    t.integer "points", default: 0
    t.bigint "user_id"
    t.bigint "url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["rejected_cancel_user_id"], name: "index_tags_on_rejected_cancel_user_id"
    t.index ["rejected_user_id"], name: "index_tags_on_rejected_user_id"
    t.index ["url_id"], name: "index_tags_on_url_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
    t.index ["verified_user_id"], name: "index_tags_on_verified_user_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string "url"
    t.string "code"
    t.integer "hits", default: 0
    t.string "title"
    t.text "description"
    t.text "screenshot"
    t.boolean "is_bot", default: false
    t.string "protocol"
    t.string "domain"
    t.string "subdomain"
    t.integer "points", default: 0
    t.string "cover_data"
    t.string "favicon_url"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_urls_on_user_id"
  end

  create_table "user_subcategories", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "subcategory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subcategory_id"], name: "index_user_subcategories_on_subcategory_id"
    t.index ["user_id"], name: "index_user_subcategories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "ip"
    t.string "username"
    t.string "avatar"
    t.boolean "admin", default: false
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "video_data", force: :cascade do |t|
    t.text "video_url"
    t.string "category"
    t.text "description"
    t.text "html_code"
    t.integer "video_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "video_tags", force: :cascade do |t|
    t.text "video_url"
    t.string "category"
    t.text "description"
    t.text "html_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "what_data", force: :cascade do |t|
    t.string "item_name"
    t.string "category"
    t.string "website_url"
    t.text "description"
    t.integer "what_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "what_tags", force: :cascade do |t|
    t.string "item_name"
    t.string "category"
    t.string "website_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "when_data", force: :cascade do |t|
    t.date "date"
    t.time "time"
    t.text "description"
    t.integer "when_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "when_tags", force: :cascade do |t|
    t.date "date"
    t.time "time"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "where_data", force: :cascade do |t|
    t.string "location"
    t.text "description"
    t.integer "where_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "where_tags", force: :cascade do |t|
    t.string "location"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "who_data", force: :cascade do |t|
    t.string "name", null: false
    t.string "account"
    t.string "website_url"
    t.text "description"
    t.integer "who_tag_id"
    t.integer "url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "who_tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "account"
    t.string "website_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "why_data", force: :cascade do |t|
    t.string "subject"
    t.string "subcategory"
    t.string "title"
    t.string "link"
    t.text "description"
    t.integer "why_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "why_tags", force: :cascade do |t|
    t.string "subject"
    t.string "subcategory"
    t.string "title"
    t.string "link"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dislikes", "tags"
  add_foreign_key "dislikes", "urls"
  add_foreign_key "dislikes", "users"
  add_foreign_key "likes", "tags"
  add_foreign_key "likes", "urls"
  add_foreign_key "likes", "users"
  add_foreign_key "tags", "urls"
  add_foreign_key "tags", "users"
  add_foreign_key "tags", "users", column: "rejected_cancel_user_id"
  add_foreign_key "tags", "users", column: "rejected_user_id"
  add_foreign_key "tags", "users", column: "verified_user_id"
  add_foreign_key "urls", "users"
  add_foreign_key "user_subcategories", "subcategories"
  add_foreign_key "user_subcategories", "users"
end
