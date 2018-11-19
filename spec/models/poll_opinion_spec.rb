require 'rails_helper'

RSpec.describe PollOpinion, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:vote_dates) }
end
