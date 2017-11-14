class ChangeFieldToNewAdmissions < ActiveRecord::Migration[5.0]
  def change
    remove_reference :new_admissions, :student
    add_reference :new_admissions, :applicant, foreign_key: false
  end
end
