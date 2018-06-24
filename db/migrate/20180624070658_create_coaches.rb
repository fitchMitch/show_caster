class CreateCoaches < ActiveRecord::Migration[5.0]
  def change
    create_table :coaches do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :cell_phone_nr
      t.string :note

      t.timestamps
    end
  end
end
