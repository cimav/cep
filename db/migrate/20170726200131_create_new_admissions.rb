class CreateNewAdmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :new_admissions do |t|
      t.references :student, foreign_key: false
      t.timestamps
    end
  end
end
