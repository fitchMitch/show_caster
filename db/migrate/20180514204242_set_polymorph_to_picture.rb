class SetPolymorphToPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :imageable_id, :integer
    add_column :pictures, :imageable_type, :string
    add_index :pictures, [:imageable_type, :imageable_id]
    remove_column :pictures , :event_id, :integer
  end
end
