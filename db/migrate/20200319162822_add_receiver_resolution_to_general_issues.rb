class AddReceiverResolutionToGeneralIssues < ActiveRecord::Migration[5.0]
  def change
    add_reference :general_issues, :student, foreign_key: false
    add_column :general_issues, :teacher, :integer
    add_column :general_issues, :addressed_to, :integer, default: 0
    add_column :general_issues, :resolution, :text
  end
end
