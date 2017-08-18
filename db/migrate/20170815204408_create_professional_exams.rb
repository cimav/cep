class CreateProfessionalExams < ActiveRecord::Migration[5.0]
  def change
    create_table :professional_exams do |t|
      t.datetime :exam_date
      t.references :student, foreign_key: false

      t.timestamps
    end
  end
end
