require 'rails_helper'

RSpec.describe PollDate, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:vote_dates) }

  describe 'scope: with_my_date_votes' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:poll_date) { create(:poll_date) }
    let!(:vote_1) do
      create(:vote_date, user_id: user.id, poll_id: poll_date.id)
    end
    let!(:vote_2) do
      create(:vote_date, user_id: user2.id, poll_id: poll_date.id)
    end
    it 'shall count the polls, not the votes' do
      expect(PollDate.with_my_date_votes(user).count).to eq(1)
    end
  end

  describe 'scope: count_my_date_votes' do
    let!(:vote_1) { create(:vote_date) }
    let(:user1) { build(:user, id: vote_1.user_id) }
    let(:poll_date_id) { vote_1.poll_id }
    let!(:vote_2) do
      create(
        :vote_date,
        poll_id: poll_date_id,
        user_id: user1.id
      )
    end
    it 'shall count the polls, not the votes' do
      expect(PollDate.count_my_date_votes(user1).count).to eq(1)
    end
  end
end
