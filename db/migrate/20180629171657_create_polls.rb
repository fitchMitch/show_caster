class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|
      t.string :question
      t.date :expiration_date
      t.string :type

      t.timestamps
    end
  end
end
