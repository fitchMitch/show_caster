require 'rails_helper'

RSpec.describe Poll, type: :model do
  it { should validate_presence_of(:expiration_date) }
  it { should validate_presence_of(:question) }
  it { should validate_length_of(:question).is_at_least(5) }
  it { should validate_length_of(:question).is_at_most(120) }

  describe 'cascade destroy' do
    let!(:poll_opinion) { create(:poll_opinion_with_answers) }
    it 'should cascasde destroy the answers' do
      expect { poll_opinion.destroy }.to change(Answer, :count).from(3).to(0)
    end
  end

  describe '.expecting_my_vote' do
    let(:user) { create(:user, :registered) }
    let!(:vote_opinion) { create(:vote_opinion, user_id: user.id) }
    let!(:vote_date) { create(:vote_date, user_id: user.id) }
    let!(:vote_date2) do
      create(
        :vote_date,
        poll_id: vote_date.poll_id,
        user_id: user.id
      )
    end
    it 'should count awaiting votes' do
      expect(Poll.expecting_my_vote(user)).to eq(2)
    end
  end

  describe '#votes_count' do
    let!(:vote_opinion) { create(:vote_opinion) }
    it 'shall count the votes for that user' do
      expect(vote_opinion.poll.votes_count).to eq(1)
    end
  end

  describe '#poll_creation_mail' do
    let(:creation_mail) { double('creation_mail') }
    let(:deliver_now) { double('deliver_now') }
    let(:a_mail) { double('a_mail') }
    subject { Poll.new }
    before do
      allow(PollMailer).to receive(:poll_creation_mail).with(subject) do
        creation_mail
      end
      allow(creation_mail).to receive(:deliver_now) { a_mail }
    end
    it 'should deliver mail' do
      expect(subject.poll_creation_mail).to eq a_mail
    end
  end

  describe '#comments_count' do
    let(:poll_opinion_thread) { create(:poll_opinion_thread) }
    let(:poll) { poll_opinion_thread.commontable }
    it 'should count 2 comments' do
      expect(poll.comments_count).to eq(2)
    end
  end

  describe '#votes_destroy' do
    let!(:vote_opinion) { create(:vote_opinion) }
    let(:poll) { vote_opinion.poll }
    it 'should count 2 comments' do
      expect { poll.votes_destroy }.to change(Vote, :count).by(-1)
    end
  end
end

RSpec.describe PollOpinion, type: :model do
  context 'with valid attributes' do
    let(:valid_attributes) do
      {
        question: 'There Dude ?',
        expiration_date: Date.today.days_since(6),
        type: 'PollOpinion'
      }
    end
    it { should have_many(:answers) }
    describe 'Persistance' do
      it 'should be verified : factory validation' do
        poll = create(:poll, valid_attributes)

        expect(poll.question).to eq(valid_attributes[:question])
        expect(poll.expiration_date).to eq(valid_attributes[:expiration_date])
        expect(poll.type).to eq(valid_attributes[:type])
      end
    end
  end
end

RSpec.describe PollDate, type: :model do
  context 'with valid attributes' do
    let(:valid_attributes) do
      {
        question: 'When Dude ?',
        expiration_date: Date.today.days_since(6),
        type: 'PollDate'
      }
    end
    it { should have_many(:answers) }
    describe 'Persistance' do
      it 'should be verified : factory validation' do
        poll = create(:poll, valid_attributes)

        expect(poll.question).to eq(valid_attributes[:question])
        expect(poll.expiration_date).to eq(valid_attributes[:expiration_date])
        expect(poll.type).to eq(valid_attributes[:type])
      end
    end
  end
end
