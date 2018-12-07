class DropTableCommittees < ActiveRecord::Migration[5.0]
  def up
    drop_table :committees
    remove_column :users, :committee_id, :integer
  end

  def down
     create_table :committees do |t|
      t.string :name, null: true
      t.string :mission, null: true

      t.timestamps
    end
  end
end
