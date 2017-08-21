class ChangeUserTypeFormatToUsers < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :user_type, :integer
  end

end
