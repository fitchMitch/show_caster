class AddPrivateToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :private_event, :boolean, false: true
    Event.all.update_all(private_event: false)
  end
end
