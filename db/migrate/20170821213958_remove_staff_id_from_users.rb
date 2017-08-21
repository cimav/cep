class RemoveStaffIdFromUsers < ActiveRecord::Migration[5.0]
  def change
      remove_column :users, :staff_id
  end
end
