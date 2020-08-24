class WithdrawProviderAndFkFromEvents < ActiveRecord::Migration[5.0]

  def up
    remove_column :events, :fk, :string
    remove_column :events, :provider, :string
  end

  def down
    add_column :events,
               :fk ,
               :string,
               default: '',
               limit: 100

    add_column :events,
               :provider ,
               :string,
               default: '',
               limit: 100

  end
end
