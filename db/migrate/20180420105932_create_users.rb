class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :email, unique: true
      t.datetime :last_sign_in_at
      t.integer :status, default: 0
      t.string :provider
      t.string :uid, unique: true
      t.string :address
      t.string :cell_phone_nr
      t.string :photo_url
      t.integer :role, default: 0
      t.string :token
      t.string :refresh_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
