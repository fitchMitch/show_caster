class CreateTheater < ActiveRecord::Migration[5.0]
  def change
    create_table :theaters do |t|
      t.string :theater_name, null: false
      t.string :location
      t.string :manager
      t.string :manager_phone
    end
  end
end
