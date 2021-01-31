class DropPreferedEmailOInUser < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :alternate_email
  end
  def down
    add_column :users, :alternate_email, :string,  limit: 120, default: 'null'
  end
end
