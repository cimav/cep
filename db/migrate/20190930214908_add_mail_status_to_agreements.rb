class AddMailStatusToAgreements < ActiveRecord::Migration[5.0]
  def change
    add_column :agreements, :notification_sent, :integer
  end
end
