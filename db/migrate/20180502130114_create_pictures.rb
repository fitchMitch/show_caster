class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.string :fk, foreign_key: true, null: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
