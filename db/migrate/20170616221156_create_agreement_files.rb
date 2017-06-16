class CreateAgreementFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :agreement_files do |t|
      t.references :agreement, foreign_key: true
      t.string :file
      t.string :name
      t.integer :file_type

      t.timestamps
    end
  end
end
