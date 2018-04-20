class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.datetime :last_sign_in_at
      t.integer :status, default: 0
      t.string :provider
      t.string :uid
      t.string :address
      t.string :cell_phone_nr
      t.string :photo_url
      t.integer :role, default: 0
      t.string :token
      t.string :refresh_token

      t.timestamps
    end
  end
end
