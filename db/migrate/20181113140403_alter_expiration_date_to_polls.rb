class AlterExpirationDateToPolls < ActiveRecord::Migration[5.0]
  def up
    change_column :polls, :expiration_date, :datetime
    Poll.find_each do |poll|
      poll.expiration_date = poll.expiration_date.end_of_day
      poll.save!
    end
  end
  def down
    change_column :polls, :expiration_date, :date
  end
end
