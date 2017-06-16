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

ActiveRecord::Schema.define(version: 20170616221423) do

  create_table "agreement_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "agreement_id"
    t.string   "file"
    t.string   "name"
    t.integer  "file_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["agreement_id"], name: "index_agreement_files_on_agreement_id", using: :btree
  end

  create_table "agreements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "meeting_id"
    t.integer  "status"
    t.integer  "agreement_type"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["meeting_id"], name: "index_agreements_on_meeting_id", using: :btree
  end

  create_table "meetings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "meeting_type"
    t.datetime "date"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "agreement_id"
    t.integer  "user_id"
    t.string   "comment"
    t.string   "answer"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["agreement_id"], name: "index_responses_on_agreement_id", using: :btree
    t.index ["user_id"], name: "index_responses_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "user_type"
    t.integer  "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_users_on_staff_id", using: :btree
  end

  add_foreign_key "agreement_files", "agreements"
  add_foreign_key "agreements", "meetings"
  add_foreign_key "responses", "agreements"
  add_foreign_key "responses", "users"
end
