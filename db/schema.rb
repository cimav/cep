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

ActiveRecord::Schema.define(version: 20170821213958) do

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
    t.index ["agreeable_id", "agreeable_type"], name: "index_agreements_on_agreeable_id_and_agreeable_type", using: :btree
    t.index ["agreeable_type", "agreeable_id"], name: "index_agreements_on_agreeable_type_and_agreeable_id", using: :btree
    t.index ["meeting_id"], name: "index_agreements_on_meeting_id", using: :btree
  end

  create_table "meetings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "meeting_type"
    t.datetime "date"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "new_admissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_new_admissions_on_student_id", using: :btree
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
    t.string   "answer"
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
