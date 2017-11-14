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

ActiveRecord::Schema.define(version: 20171113222439) do

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
    t.string   "agreeable_type"
    t.integer  "agreeable_id"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "decision"
    t.string   "id_key"
    t.integer  "consecutive"
    t.index ["agreeable_id", "agreeable_type"], name: "index_agreements_on_agreeable_id_and_agreeable_type", using: :btree
    t.index ["agreeable_type", "agreeable_id"], name: "index_agreements_on_agreeable_type_and_agreeable_id", using: :btree
    t.index ["meeting_id"], name: "index_agreements_on_meeting_id", using: :btree
  end

  create_table "audits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes", limit: 65535
    t.integer  "version",                       default: 0
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

  create_table "meetings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "meeting_type"
    t.datetime "date"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "id_key"
    t.integer  "consecutive"
  end

  create_table "new_admissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "applicant_id"
    t.index ["applicant_id"], name: "index_new_admissions_on_applicant_id", using: :btree
  end

  create_table "professional_exams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "exam_date"
    t.integer  "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_professional_exams_on_student_id", using: :btree
  end

  create_table "responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "agreement_id"
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "answer"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["agreement_id"], name: "index_responses_on_agreement_id", using: :btree
    t.index ["user_id"], name: "index_responses_on_user_id", using: :btree
  end

  create_table "synod_designations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "student_id"
    t.integer  "synodal1"
    t.integer  "synodal2"
    t.integer  "synodal3"
    t.integer  "synodal4"
    t.integer  "synodal5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_synod_designations_on_student_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "agreement_files", "agreements"
  add_foreign_key "agreements", "meetings"
  add_foreign_key "responses", "agreements"
  add_foreign_key "responses", "users"
end
