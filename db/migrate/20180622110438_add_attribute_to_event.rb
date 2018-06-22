class AddAttributeToEvent < ActiveRecord::Migration[5.0]
  def change
      add_column :events, :type, :string, default: 'Performance'
      add_index :events, :type
  end
end
