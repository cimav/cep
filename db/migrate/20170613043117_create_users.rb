class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :user_type
      t.references :staff, foreign_key: false

      t.timestamps
    end
  end
end
