require 'rails_helper'
RSpec.describe Answer, type: :model do
  context 'validations' do
    let!(:valid_attributes) do
      {
        answer_label: 'an answer',
        date_answer: Date.today.weeks_since(3)
      }
    end
    let(:answer) { FactoryBot.build(:answer, date_answer: nil) }
    subject { answer }

    it { should validate_presence_of :answer_label }
    it { should validate_length_of(:answer_label).is_at_least(3) }
    it { should validate_length_of(:answer_label).is_at_most(100) }
    it { should belong_to(:poll_opinion) }
    it { should belong_to(:poll_secret_ballot) }
    it { should belong_to(:poll_date) }
  end

  context 'Persistance (opinion)' do
    let!(:valid_attributes) do
      {
        answer_label: 'an answer',
        date_answer: Date.today.weeks_since(3)
      }
    end
    let(:answ) { create(:answer_opinion, valid_attributes) }
    subject { answ }

    it { should belong_to(:poll_opinion) }
    it 'should be verified : factory validation' do
      expect(answ.answer_label).to eq(valid_attributes[:answer_label])
      expect(answ.date_answer.strftime('%Y-%m-%d')).to eq(
        valid_attributes[:date_answer].to_s
      )
    end
  end

  context 'Persistance (date)' do
    let!(:valid_attributes) do
      {
        answer_label: 'not an option',
        date_answer: Date.today.weeks_since(3)
      }
    end
    let(:answ) { create(:answer_date, valid_attributes) }
    subject { answ }

    it { should belong_to(:poll_opinion) }
    it 'should be verified : factory validation' do
      expect(answ.answer_label).to eq(valid_attributes[:answer_label])
      expect(answ.date_answer.strftime('%Y-%m-%d')).to eq(
        valid_attributes[:date_answer].to_s
      )
    end
  end

  context 'with invalid attributes' do
    it 'tolerates empty fields but the answer' do
      answer = build(:answer, answer_label: '', date_answer: nil)
      expect(answer).not_to be_valid
    end
  end

  # describe '#order_by_vote_count' do
  #   let(:poll) { create(:poll_opinion_with_answers) }
  #   let(:vote_opinion) do
  #     create(
  #       :poll_opinion_with_answers,
  #       poll_id: poll.id,
  #       answer_id: poll.answers.second.id,
  #       user_id: poll.owner.id
  #     )
  #   end
  #   it 'should range the second answer first' do
  #     res = Answer.order_by_vote_count(poll)
  #     byebug
  #     expect(res.first.id).to eq(poll.answers.second.id)
  #   end
  #
  # end

  describe '#no_date_in_the_past' do
    let(:answer_in_the_future) do
      build(
        :answer_opinion,
        date_answer: Time.zone.now + 1.day
      )
    end
    let(:answer_in_the_past) do
      build(
        :answer_opinion,
        date_answer: Time.zone.now - 1.day
      )
    end
    let(:answer_empty_date) { build(:answer_opinion, date_answer: nil) }

    it 'should return nil with a future date' do
      expect(answer_in_the_future.no_date_in_the_past).to be_nil
    end

    it 'should launch errors when answers are in the past' do
      expect(
        answer_in_the_past.no_date_in_the_past
      ).to eq [I18n.t('answers.in_the_past_error')]
    end
    it 'should launch errors when answers are in nil' do
      expect(
        answer_empty_date.no_date_in_the_past
      ).to eq [I18n.t('answers.in_the_past_error')]
    end
  end
end
