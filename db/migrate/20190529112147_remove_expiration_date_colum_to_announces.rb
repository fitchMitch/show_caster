class RemoveExpirationDateColumToAnnounces < ActiveRecord::Migration[5.0]
  def change
    remove_column :announces, :expiration_date, :datetime
  end
end
