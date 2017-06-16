class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.integer :meeting_type
      t.datetime :date
      t.integer :status

      t.timestamps
    end
  end
end
