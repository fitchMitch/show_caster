# == Schema Information
#
# Table name: pictures
#
#  id                 :integer          not null, primary key
#  fk                 :string
#  event_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  note               :string
#  descro             :string
#

FactoryBot.define do
  factory :picture do
    fk "MyString"
    event
    photo  { File.new("#{Rails.root}/spec/support/fixtures/pbhinanagkgpkadi.jpg") }
  end
end
