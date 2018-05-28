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

FactoryBot.define do
  factory :picture do
    fk "aForeying_Key"
    photo  { File.new("#{Rails.root}/spec/support/fixtures/pbhinanagkgpkadi.jpg") }
    factory :event_picture do
      imageable event
    end
    factory :user_picture do
      imageable user
    end
  end
end
