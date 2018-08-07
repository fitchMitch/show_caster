class AddOwnerColumnToPoll < ActiveRecord::Migration[5.0]
  def change
    add_reference :polls, :owner, index: true
    add_foreign_key :polls, :users, column: :owner_id
  end
end
