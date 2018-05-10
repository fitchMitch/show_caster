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

require 'rails_helper'

RSpec.describe Picture, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
