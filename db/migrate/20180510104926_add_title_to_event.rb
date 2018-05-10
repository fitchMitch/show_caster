class AddTitleToEvent < ActiveRecord::Migration[5.0]
  def change
          add_column :events, :title, :string,  null:true
  end
end
