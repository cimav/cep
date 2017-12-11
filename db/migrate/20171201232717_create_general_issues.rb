class CreateGeneralIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :general_issues do |t|
      t.string :subject
      t.timestamps
    end
  end
end
