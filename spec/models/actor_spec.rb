# == Schema Information
#
# Table name: actors
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  stage_role :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Actor, type: :model do

  it { should belong_to(:performance) }
  it { should belong_to(:user) }
  it { should define_enum_for(:stage_role) }

  # it "created from factory shoud add a new Actor " do
  #   expect { create(:actor) }.to change{ Actor.count }.by(1)
  # end

end
