class CreateSynodDesignations < ActiveRecord::Migration[5.0]
  def change
    create_table :synod_designations do |t|

      t.references :student, foreign_key: false
      t.references :agreement, foreign_key: true
      t.integer :synodal1
      t.integer :synodal2
      t.integer :synodal3
      t.integer :synodal4
      t.integer :synodal5

      t.timestamps
    end
  end
end
