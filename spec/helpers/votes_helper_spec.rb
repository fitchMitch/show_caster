require 'rails_helper'

RSpec.describe VotesHelper, type: :helper do
  let!(:poll1)        { build(:poll, type: nil) }
  let!(:poll_opinion) { create(:poll_opinion) }
  let!(:poll_date)    { create(:poll_date) }
  let!(:poll2)        { build(:poll, type: 'gaouda') }

  describe '#others_votes_list' do
    let!(:votop) { create(:vote_opinion) }
    it 'shall display name anyway' do
      expect(
        helper.others_votes_list(votop.answer, votop.user)
      ).to include(votop.user.first_and_l)
    end
  end

  describe '#winner_line' do
    let!(:winners) { [2] }
    let(:answer_vote) { { answer: object } }
    context 'when a winner' do
      let(:object) { double('object', id: 2) }
      it 'shall give an image to the winner line' do
        expect(
          helper.winner_line(answer_vote, winners)
        ).to include('009-medal')
      end
    end
    context 'when not a winner' do
      let(:object) { double('object', id: 1) }
      it 'shall give an image to the winner line' do
        expect(helper.winner_line(answer_vote, winners)).to include('transp')
      end
    end
  end
end
