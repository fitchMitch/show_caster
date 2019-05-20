class CreateAnnounces < ActiveRecord::Migration[5.0]
  def change
    create_table :announces do |t|
      t.string :title
      t.string :body
      t.datetime :time_start
      t.datetime :time_end
      t.datetime :expiration_date

      t.timestamps
    end
    add_reference :announces, :author, index: true
    add_foreign_key :announces, :users, column: :author_id
  end
end
