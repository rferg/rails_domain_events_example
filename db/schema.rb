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

ActiveRecord::Schema[7.0].define(version: 2023_04_07_135151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forum_comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "forum_post_id", null: false
    t.text "body", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_post_id"], name: "index_forum_comments_on_forum_post_id"
    t.index ["user_id"], name: "index_forum_comments_on_user_id"
  end

  create_table "forum_posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "title", null: false
    t.text "body", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_forum_posts_on_user_id"
  end

  create_table "moderation_cases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_moderation_cases_on_user_id"
  end

  create_table "notification_contents", force: :cascade do |t|
    t.text "title", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notification_instances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "notification_content_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_content_id"], name: "index_notification_instances_on_notification_content_id"
    t.index ["user_id"], name: "index_notification_instances_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "forum_comments", "forum_posts"
  add_foreign_key "forum_comments", "users"
  add_foreign_key "forum_posts", "users"
  add_foreign_key "moderation_cases", "users"
  add_foreign_key "notification_instances", "notification_contents"
  add_foreign_key "notification_instances", "users"
end
