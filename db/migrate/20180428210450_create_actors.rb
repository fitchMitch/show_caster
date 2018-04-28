class CreateActors < ActiveRecord::Migration[5.0]
  def change
    create_table :actors do |t|
      t.integer :stage_role
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
