class AddFormerConnexionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :former_connexion_at, :datetime
  end
end
