require 'rails_helper'

RSpec.describe VoteOpinion, type: :model do
  context 'validations' do
    let(:vote_opinion) { FactoryBot.build(:vote_opinion) }
    subject { vote_opinion }

    it { should belong_to(:poll) }
    it { should belong_to(:answer) }
    it { should belong_to(:user) }
    it { should validate_presence_of :user }
    it { should validate_presence_of :answer }
    it { should validate_presence_of :poll }
  end

  context 'Persistance (opinion)' do
    let!(:symfields) { %i[vote_label] }
    let!(:valid_attributes_opinion) { build(:vote_opinion).attributes }
    let!(:vote_op) { create(:vote_opinion, valid_attributes_opinion) }

    it 'when done through factory should be ok' do
      symfields.each do |s_field|
        expect(
          vote_op.send(s_field)
        ).to be == valid_attributes_opinion[s_field.to_s]
      end
    end
  end

  context 'with invalid attributes' do
    let(:valid_attributes_opinion) { build(:vote_opinion).attributes }
    let(:invalid_poll_attribute) do
      FactoryBot.build(:vote_opinion, poll_id: nil).attributes
    end
    let(:invalid_user_attribute) do
      FactoryBot.build(:vote_opinion, user_id: nil).attributes
    end
    it 'tolerates empty fields but the poll_id' do
      vote = build(:vote_opinion, invalid_poll_attribute)
      expect(vote).not_to be_valid
    end
    it 'tolerates empty fields but the user_id' do
      vote = build(:vote_opinion, invalid_user_attribute)
      expect(vote).not_to be_valid
    end
  end

  describe '#clean_votes' do
    let(:vote_opinion) { create(:vote_opinion) }
    before do
      create(
        :vote_date,
        user_id: vote_opinion.user_id
      )
      v2 = create(
        :vote_opinion,
        user_id: vote_opinion.user_id
      )
      v2.poll_id = vote_opinion.poll_id
      v2.save
    end
    it { expect(VoteOpinion.count).to eq(2) }
    it 'should show a VoteOpinion change by 2' do
      expect{vote_opinion.clean_votes}.to change(VoteOpinion, :count).by(-2)
    end
  end
end
