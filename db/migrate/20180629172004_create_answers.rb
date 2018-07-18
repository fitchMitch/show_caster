class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.string :answer
      t.datetime :date_answer
      t.references :poll, foreign_key: true

      t.timestamps
    end
  end
end
