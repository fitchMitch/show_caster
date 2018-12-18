class AddAlternateEmailToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :alternate_email, :string, null: true
  end
end
