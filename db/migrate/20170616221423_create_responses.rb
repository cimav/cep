class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :agreement, foreign_key: true
      t.references :user, foreign_key: true
      t.string :comment
      t.string :answer

      t.timestamps
    end
  end
end
