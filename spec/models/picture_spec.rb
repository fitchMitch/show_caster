# == Schema Information
#
# Table name: pictures
#
#  id                 :integer          not null, primary key
#  fk                 :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  note               :string
#  descro             :string
#  imageable_id       :integer
#  imageable_type     :string
#

require 'rails_helper'

RSpec.describe Picture, type: :model do
  context "with valid attributes" do
    let (:valid_attributes) {
      { note: "An note",
        descro: "A description",
        photo: File.new("#{Rails.root}/spec/support/fixtures/pbhinanagkgpkadi.jpg")
      }
    }

    it { should have_attached_file(:photo) }
    it { should validate_attachment_presence(:photo) }
    it { should validate_attachment_content_type(:photo).
                  allowing('image/png', 'image/gif').
                  rejecting('text/plain', 'text/xml') }
  end


end
