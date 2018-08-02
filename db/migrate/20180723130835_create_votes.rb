class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :poll, foreign_key: true
      t.references :answer, foreign_key: true
      t.references :user, foreign_key: true
      t.string :type
      t.string :comment
      t.integer :vote_label

      t.timestamps
    end

  end
end
