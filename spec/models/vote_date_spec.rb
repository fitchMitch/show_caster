require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:symfields) { %i[vote_label] }
  context 'validations' do
    let(:vote) { FactoryBot.build(:vote_opinion)}
    subject { vote }

    it { should belong_to(:poll) }
    it { should belong_to(:answer) }
    it { should belong_to(:user) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:answer) }
    it { should validate_presence_of(:poll) }
  end

  context 'Persistance (opinion)' do
    let!(:valid_attributes_opinion) { build(:vote_opinion).attributes }
    let!(:vote_op) { create(:vote_opinion, valid_attributes_opinion) }

    it 'when done through factory should be ok' do
      symfields.each do |s_field|
        expect(vote_op.send(s_field)).to be == valid_attributes_opinion[s_field.to_s]
      end
    end
  end

  context 'Persistance (date)' do
    let!(:valid_attributes_date) { build(:vote_date).attributes }
    let(:vote_d) { create(:vote_date, valid_attributes_date) }

    it 'when done through factory should be ok' do
      symfields.each do |s_field|
        expect(vote_d.send(s_field)).to be == valid_attributes_date[s_field.to_s]
      end
    end
  end

  context 'with invalid attributes' do
    let!(:invalid_poll_attribute) do
      FactoryBot.build(:vote_date, poll_id: nil)
                .attributes
    end
    let!(:invalid_user_attribute) do
      FactoryBot.build(:vote_date, user_id: nil)
                .attributes
    end
    it 'tolerates empty fields but the poll_id' do
      vote = build(:vote_date, invalid_poll_attribute)
      expect(vote).not_to be_valid
    end
    it 'tolerates empty fields but the user_id' do
      vote = build(:vote_date, invalid_user_attribute)
      expect(vote).not_to be_valid
    end
  end

  describe '#clean_votes' do
    let(:vote_date) { create(:vote_date) }
    let(:vote_date2) do
      build(
        :vote_date,
        poll_id: vote_date.poll_id,
        user_id: vote_date.user_id
      )
    end
    let(:vote_opinion) do
      create(
        :vote_opinion,
        poll_id: vote_date.poll_id,
        user_id: vote_date.user_id
      )
    end
    it 'shall delete vote_date only' do
      expect { vote_date2.clean_votes }.to change(VoteDate, :count).by(1)
    end
  end
end
