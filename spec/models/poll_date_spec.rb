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
    # The following creates two poll dates, 1 vote
    let!(:vote1) { create(:vote_date) }
    let!(:user1) { build(:user, id: vote1.user_id) }

    before do
      vote2 = create(:vote_date, user_id: user1.id)
      vote2.poll_id = vote1.poll_date.id
      vote2.save
    end
    it { expect(PollDate.count).to eq(4) }
    it { expect(VoteDate.count).to eq(2) }
    it 'shall count the votes grouped by polls' do
      expect(PollDate.count_my_date_votes(user1).count).to eq(1)
    end
  end

  describe '#fill_answers_votes' do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:vote_date) { create(:vote_date, user_id: user.id) }
    let!(:poll_date2) { vote_date.poll }
    let!(:answer) { vote_date.answer }
    it 'shall list the answers voted by each user' do
      vote_date.save
      expect(poll_date2.fill_answers_votes(user)).to eq(
        [{ answer: answer, vote: vote_date }]
      )
    end
    it 'shall return a hash with empty vote when no vote is to be listed' do
      vote_date.save
      expect(poll_date2.fill_answers_votes(user2)).to eq(
        [{ answer: answer, vote: nil }]
      )
    end
  end

  describe '.best_hash_values' do
    let(:hash) do
      {
        key1: 1,
        key2: 2,
        key3: 2,
        key4: 0
      }
    end
    it 'should isolate best values' do
      expect(PollDate.best_hash_values(hash)).to eq({ key2: 2, key3: 2 })
    end
  end

  describe '#best_dates_answer' do
    let!(:vote_date1) { create(:vote_date, vote_label: 'yess') }
    let!(:vote_date2) { create(:vote_date, vote_label: 'yess') }
    let!(:vote_date3) { create(:vote_date, vote_label: 'maybe') }
    let(:expectect_result) { {key: 2} }
    it 'should count the best answers' do
      vote_date2.answer_id = vote_date1.answer_id
      vote_date3.answer_id = vote_date1.answer_id
      vote_date2.poll_id = vote_date1.poll_id
      vote_date3.poll_id = vote_date1.poll_id
      # vote_date1 is to be saved, too !!
      [vote_date1, vote_date2, vote_date3].each(&:save)
      poll = Poll.find(vote_date1.poll_id)
      expect(poll.best_dates_answer).to eq(Hash[vote_date1.answer_id, 2])
    end
  end
end
