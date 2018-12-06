class DropTableCommittees < ActiveRecord::Migration[5.0]
  def change
    drop_table :committees
  end
end
