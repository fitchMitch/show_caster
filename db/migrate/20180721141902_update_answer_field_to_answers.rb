class UpdateAnswerFieldToAnswers < ActiveRecord::Migration[5.0]
  def change
    rename_column :answers, :answer, :answer_label
  end
end
