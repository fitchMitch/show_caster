class RemoveNoteAndDescroFromPictures < ActiveRecord::Migration[5.0]
  def change
    remove_column :pictures, :note, :string
    remove_column :pictures, :descro, :string
  end
end
