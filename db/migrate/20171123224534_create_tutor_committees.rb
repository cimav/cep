class CreateTutorCommittees < ActiveRecord::Migration[5.0]
  def change
    create_table :tutor_committees do |t|
      t.references :student, foreign_key: false
      t.integer :tutor1
      t.integer :tutor2
      t.integer :tutor3
      t.integer :tutor4
      t.integer :tutor5

      t.timestamps
    end
  end
end
