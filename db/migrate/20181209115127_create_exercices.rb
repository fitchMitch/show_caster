class CreateExercices < ActiveRecord::Migration[5.0]
  def up
    create_table :exercices do |t|
      t.string :title,         null: false
      t.text :instructions,    null: false
      t.integer :category,     default: 0
      t.integer :energy_level, default: 1
      t.string :promess,       null: true
      t.string :focus,         null: true
      t.integer :max_people,   default: 0

      t.timestamps
    end
  end
  def down
    drop_table :exercices
  end
end
