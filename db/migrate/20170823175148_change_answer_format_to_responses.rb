class ChangeAnswerFormatToResponses < ActiveRecord::Migration[5.0]
  def up
    change_column :responses, :answer, :integer
  end
end
