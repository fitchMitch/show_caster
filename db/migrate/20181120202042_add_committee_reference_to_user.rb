class AddCommitteeReferenceToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :committee, index: true
  end
end
