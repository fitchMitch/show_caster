class CreateTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :teachers do |t|
      t.references :teachable, polymorphic: true
      t.references :event, foreign_key: true
      t.timestamps
    end
  end
end
