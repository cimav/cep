class ChangeFieldToResponse < ActiveRecord::Migration[5.0]
  def up
    change_column :responses, :answer, :string
    change_column :agreements, :decision, :string
  end
  def down
    change_column :responses, :answer, :integer
    change_column :agreements, :decision, :integer
  end
end
