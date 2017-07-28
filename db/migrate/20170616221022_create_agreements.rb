class CreateAgreements < ActiveRecord::Migration[5.0]
  def change
    create_table :agreements do |t|
      t.references :meeting, foreign_key: true
      t.integer :status
      t.belongs_to :agreeable, polymorphic: true
      t.string :description

      t.timestamps
    end
    add_index :agreements, [:agreeable_id, :agreeable_type]
  end
end
