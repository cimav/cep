class ChangeFieldToAgreement < ActiveRecord::Migration[5.0]
  def up
    rename_column :agreements, :description, :notes
  end
  def down
    rename_column :agreements, :notes, :description
  end
end
