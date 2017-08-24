class AddDecisionToAgreements < ActiveRecord::Migration[5.0]
  def change
    add_column :agreements, :decision, :integer
  end
end
