class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :committees do |t|
      t.string :name, null: true
      t.string :mission, null: true

      t.timestamps
    end
  end
end
