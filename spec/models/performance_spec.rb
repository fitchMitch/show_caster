require 'rails_helper'

RSpec.describe Performance, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:theater) }
  it { should have_many(:actors) }
  it { should validate_presence_of(:event_date) }
  it 'should count an actor at least which stage_role is player'
end
