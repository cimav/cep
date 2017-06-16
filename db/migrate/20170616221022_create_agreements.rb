class CreateAgreements < ActiveRecord::Migration[5.0]
  def change
    create_table :agreements do |t|
      t.references :meeting, foreign_key: true
      t.integer :status
      t.integer :agreement_type
      t.string :description

      t.timestamps
    end
  end
end
