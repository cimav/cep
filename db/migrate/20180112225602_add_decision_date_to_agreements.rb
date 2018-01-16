class AddDecisionDateToAgreements < ActiveRecord::Migration[5.0]
  def change
    add_column :agreements, :decision_date, :datetime
  end
end
