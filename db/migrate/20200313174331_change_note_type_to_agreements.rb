class ChangeNoteTypeToAgreements < ActiveRecord::Migration[5.0]
  def change
    change_column :agreements, :notes, :text
  end
end
