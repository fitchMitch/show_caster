require 'rails_helper'

RSpec.describe VotesHelper, type: :helper do
  let!(:poll1)        { build(:poll, type: nil) }
  let!(:poll_opinion) { create(:poll_opinion) }
  let!(:poll_date)    { create(:poll_date) }
  let!(:poll2)        { build(:poll, type: 'gaouda') }
  describe '#new_vote_path' do
    it 'shall display nil' do
      expect(helper.new_vote_path(poll1)).to eq(nil)
      expect(helper.new_vote_path(poll_opinion)).to include(helper.updown_icons)
      expect(helper.new_vote_path(poll_date)).to include(helper.updown_icons)
      expect(helper.new_vote_path(poll2)).to eq(nil)
    end
  end

  describe '#others_votes_list' do
    let!(:votop) { create(:vote_opinion) }
    it 'shall display name anyway' do
      expect(
        helper.others_votes_list(votop.answer, votop.user)
      ).to include(votop.user.first_and_l)
    end
  end
end
