class RemoveFieldFromAgreementFiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :agreement_files, :file
  end
end
