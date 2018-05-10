class AddAttachmentPhotoToPictures < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :pictures, :photo
    add_column :pictures, :note, :string
    add_column :pictures, :descro, :string
  end

  def self.down
    remove_attachment :pictures, :photo
    remove_column :pictures, :note, :string
    remove_column :pictures, :descro, :string
  end
end
