class AddPolymorphicCourseToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :courseable_id, :integer
    add_column :events, :courseable_type, :string
    add_index :events, [:courseable_type, :courseable_id]

  end
end
