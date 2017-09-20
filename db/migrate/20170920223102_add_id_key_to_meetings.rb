class AddIdKeyToMeetings < ActiveRecord::Migration[5.0]
  def change
    add_column :meetings, :id_key, :string
    add_column :meetings, :consecutive, :integer
  end
end
