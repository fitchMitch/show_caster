# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  answer_label :string
#  date_answer  :datetime
#  poll_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Answer, type: :model do

  context "validations" do
    let!(:valid_attributes) {
      {
        answer_label: "an answer",
        date_answer: Date.today.weeks_since(3)
      }
    }
    let(:answer) { FactoryBot.build(:answer, date_answer: nil)}
    subject { answer }

    it { should validate_presence_of (:answer_label) }
    it { should validate_length_of(:answer_label).is_at_least(3) }
    it { should validate_length_of(:answer_label).is_at_most(100) }
  end

  context  "Persistance (opinion)" do
    let!(:valid_attributes) {
      {
        answer_label: "an answer",
        date_answer: Date.today.weeks_since(3)
      }
    }
    let(:answ){ create(:answer_opinion, valid_attributes)}
    subject { answ }

    it { should belong_to(:poll_opinion)}

    it "should be verified : factory validation" do
      expect(answ.answer_label).to eq(valid_attributes[:answer_label])
      expect(answ.date_answer.strftime("%Y-%m-%d")).to eq(valid_attributes[:date_answer].to_s)
    end
  end

  context  "Persistance (date)" do
    let!(:valid_attributes) {
      {
        answer_label: "not an option",
        date_answer: Date.today.weeks_since(3)
      }
    }
    let(:answ){ create(:answer_date, valid_attributes)}
    subject { answ }

    it { should belong_to(:poll_opinion)}

    it "should be verified : factory validation" do
      expect(answ.answer_label).to eq(valid_attributes[:answer_label])
      expect(answ.date_answer.strftime("%Y-%m-%d")).to eq(valid_attributes[:date_answer].to_s)
    end
  end

  context "with invalid attributes" do
    it "tolerates empty fields but the answer" do
      answer = build(:answer, answer_label: "", date_answer: nil)
      expect(answer).not_to be_valid
    end
  end
end
