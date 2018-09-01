class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.datetime :event_date
      t.integer :duration
      t.integer :progress, default: 0
      t.text :note,  null: true
      t.references :user, foreign_key: true
      t.references :theater, foreign_key: true
      t.string :fk,  null: true
      t.string :provider,  null: true

      t.timestamps
    end
  end
end
