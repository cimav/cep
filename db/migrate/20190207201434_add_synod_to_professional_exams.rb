class AddSynodToProfessionalExams < ActiveRecord::Migration[5.0]
  def change
    add_column :professional_exams, :synod1, :string
    add_column :professional_exams, :synod2, :string
    add_column :professional_exams, :synod3, :string
    add_column :professional_exams, :synod4, :string
    add_column :professional_exams, :synod5, :string
    add_column :professional_exams, :synod6, :string
    add_column :professional_exams, :synod7, :string
  end
end
