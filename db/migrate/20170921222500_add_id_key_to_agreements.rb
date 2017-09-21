class AddIdKeyToAgreements < ActiveRecord::Migration[5.0]
  def change
    add_column :agreements, :id_key, :string
    add_column :agreements, :consecutive, :integer
  end
end
