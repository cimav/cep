class ChangeFieldToResponse < ActiveRecord::Migration[5.0]
  def change
    change_column :responses, :answer, :string
  end
end
