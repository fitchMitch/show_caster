require 'rails_helper'

RSpec.describe Poll, type: :model do
  it { should validate_presence_of(:expiration_date) }
  it { should validate_presence_of(:question) }
  it { should validate_length_of(:question).is_at_least(5) }
  it { should validate_length_of(:question).is_at_most(120) }

  describe 'scope last_results' do
    let!(:now) { Time.zone.now }
    let!(:poll_opinion) { create(:poll_opinion, expiration_date: (now - 2.days)) }
    context 'when one poll has expired and a user not connected for 10 days' do
      let(:user) { create(:user, last_sign_in_at: now - 10.days) }
      it 'should count a single result' do
        expect(Poll.last_results(user).count).to eq(1)
      end
    end
    context 'when one poll has expired and a user not connected for 10 days' do
      let(:user) { create(:user, last_sign_in_at: now - 1.days) }
      it 'should count a single result' do
        expect(Poll.last_results(user).count).to eq(0)
      end
    end
  end

  describe 'cascade destroy' do
    let!(:poll_opinion) { create(:poll_opinion_with_answers) }
    it 'should cascasde destroy the answers' do
      expect { poll_opinion.destroy }.to change(Answer, :count).from(3).to(0)
    end
  end

  describe '.expecting_my_vote' do
    let(:user) { create(:user, :registered) }
    subject(:awaiting_votes) { Poll.expecting_my_vote(user) }
    context 'when poll is not expired' do
      before do
        create(:poll_opinion, expiration_date: Time.zone.now + 2.days)
        create(:poll_date, expiration_date: Time.zone.now + 20.days)
      end
      it { expect(awaiting_votes).to eq(2) }
    end
    context 'when poll is expired' do
      before do
        create(:poll_opinion, expiration_date: Time.zone.now - 2.days)
      end
      it { expect(awaiting_votes).to eq(0) }
    end
    context 'when having one of two polls answered ' do
      before do
        #the following creates tow polls where one is answered
        create(:vote_date, user_id: user.id)
      end
      it { expect(awaiting_votes).to eq(1) }
    end
    context 'when having two of five polls answered ' do
      before do
        #the following twice creates polls where one is answered
        create(:vote_date, user_id: user.id)
        create(:vote_opinion, user_id: user.id)
        create(:poll_secret_ballot)
      end
      it { expect(awaiting_votes).to eq(3) }
    end
    context 'when having two of five polls answered ' do
      before do
        #the following twice creates polls where one is answered
        v1 = create(:vote_date, user_id: user.id)
        v2 = create(:vote_date, user_id: user.id)
        v2.poll_id = v1.poll_id
        v2.save
      end
      it { expect(awaiting_votes).to eq(3) }
    end
  end

  describe '#votes_count' do
    let!(:vote_opinion) { create(:vote_opinion) }
    it 'shall count the votes for that user' do
      expect(vote_opinion.poll.votes_count).to eq(1)
    end
  end

  # describe '#poll_creation_mail' do
  #   let(:creation_mail) { double('creation_mail') }
  #   let(:deliver_later) { double('deliver_later') }
  #   let(:a_mail) { double('a_mail') }
  #   subject { Poll.new }
  #   before do
  #     allow(PollMailer).to receive(:poll_creation_mail).with(subject) do
  #       creation_mail
  #     end
  #     allow(creation_mail).to receive(:deliver_later) { a_mail }
  #   end
  #   it 'should deliver mail' do
  #     expect(subject.poll_creation_mail).to eq a_mail
  #   end
  # end

  describe '#missing_voters_ids' do
    let(:user_active) { double('user_active') }
    let!(:user) { create(:user) }
    let(:poll) { vote_opinion.poll }
    let(:poll_d) { vote_date.poll }
    before :each do
      allow(User).to receive(:active) { user_active }
      allow(user_active).to receive(:pluck) { [100, 200, 300, user.id] }
    end
    context 'when poll\'s type is PollOpinion' do
      subject { poll.missing_voters_ids }
      let(:vote_opinion) { create(:vote_opinion, user_id: user.id) }
      it { expect(subject).to eq [100, 200, 300] }
    end
    context 'when poll\'s type is PollDate' do
      subject { poll_d.missing_voters_ids }
      let(:vote_date) { create(:vote_date, user_id: user.id) }
      let(:vote_date2) do
        create(
          :vote_date,
          poll_id: vote_date2.poll_id,
          user_id: user.id
        )
      end
      it { expect(subject).to eq [100, 200, 300] }
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
  it { should have_many(:answers) }
  it { should have_many(:vote_opinions) }
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
        expect(poll.expiration_date.to_date).to eq(
          valid_attributes[:expiration_date].to_date
        )
        expect(poll.type).to eq(valid_attributes[:type])
      end
    end
  end

  describe '#answer_id_sorted_by_vote_count' do
    let(:user2) { create(:user) }
    let!(:poll_opinion) { create(:poll_opinion_with_answers) }
    let!(:vote_opinion) do
      create(
        :vote_opinion,
        user_id: poll_opinion.owner.id,
        answer_id: poll_opinion.answers.second.id,
        poll_id: poll_opinion.id
      )
    end
    let!(:vote_opinion2) do
      create(
        :vote_opinion,
        user_id: user2.id,
        answer_id: poll_opinion.answers.third.id,
        poll_id: poll_opinion.id
      )
    end
    let!(:vote_opinion3) do
      create(
        :vote_opinion,
        user_id: user2.id,
        answer_id: poll_opinion.answers.third.id,
        poll_id: poll_opinion.id
      )
    end
    it 'should let the second answer rank first' do
      second_item_id = poll_opinion.answers.second.id
      third_item_id = poll_opinion.answers.third.id
      expect(poll_opinion.answer_id_sorted_by_vote_count).to eq(
        [
          [third_item_id, 2],
          [second_item_id, 1]
        ]
      )
    end
  end
  describe '#answers_sorted_by_vote_count' do
    let(:user2) { create(:user) }
    let!(:poll_opinion) { create(:poll_opinion_with_answers) }
    let!(:vote_opinion) do
      create(
        :vote_opinion,
        user_id: poll_opinion.owner.id,
        answer_id: poll_opinion.answers.second.id,
        poll_id: poll_opinion.id
      )
    end
    let!(:vote_opinion2) do
      create(
        :vote_opinion,
        user_id: user2.id,
        answer_id: poll_opinion.answers.third.id,
        poll_id: poll_opinion.id
      )
    end
    let!(:vote_opinion3) do
      create(
        :vote_opinion,
        user_id: user2.id,
        answer_id: poll_opinion.answers.third.id,
        poll_id: poll_opinion.id
      )
    end
    it 'should let the second answer rank first' do
      second_item_id = poll_opinion.answers.second
      third_item_id = poll_opinion.answers.third
      expect(poll_opinion.answers_sorted_by_vote_count.to_a).to eq(
        [third_item_id, second_item_id]
      )
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
        # TODO
        expect(poll.expiration_date.to_date).to eq(
          valid_attributes[:expiration_date].to_date
        )
        expect(poll.type).to eq(valid_attributes[:type])
      end
    end
  end
end

RSpec.describe PollSecretBallot, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:vote_opinions) }
end
