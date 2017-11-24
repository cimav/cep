class CreateThesisDirectors < ActiveRecord::Migration[5.0]
  def change
    create_table :thesis_directors do |t|
      t.references :student, foreign_key: false
      t.integer :director

      t.timestamps
    end
  end
end
