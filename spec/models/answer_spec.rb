# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  answer      :string
#  date_answer :datetime
#  poll_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Answer, type: :model do

  context "validations" do
    let!(:valid_attributes) {
      {
        answer: "an answer",
        date_answer: Date.today.weeks_since(3)
      }
    }
    let(:answer) {FactoryBot.build(:answer)}
    subject { answer }

    it { should validate_presence_of (:answer) }
    it { should validate_length_of(:answer).is_at_least(3) }
    it { should validate_length_of(:answer).is_at_most(100) }
  end

  context  "Persistance (opinion)" do
    let!(:valid_attributes) {
      {
        answer: "an answer",
        date_answer: Date.today.weeks_since(3)
      }
    }
    let(:answ){create(:answer_opinion,valid_attributes)}
    subject { answ }

    it { should belong_to(:poll_opinion)}

    it "should be verified : factory validation" do
      expect(answ.answer).to eq(valid_attributes[:answer])
      expect(answ.date_answer.strftime("%Y-%m-%d")).to eq(valid_attributes[:date_answer].to_s)
    end
  end

  context  "Persistance (date)" do
    let!(:valid_attributes) {
      {
        answer: "not an option",
        date_answer: Date.today.weeks_since(3)
      }
    }
    let(:answ){create(:answer_date,valid_attributes)}
    subject { answ }

    it { should belong_to(:poll_opinion)}

    it "should be verified : factory validation" do
      expect(answ.answer).to eq(valid_attributes[:answer])
      expect(answ.date_answer.strftime("%Y-%m-%d")).to eq(valid_attributes[:date_answer].to_s)
    end
  end

  context "with invalid attributes" do
    it "tolerates empty fields but the answer" do
      answer = build(:answer, answer: "")
      expect(answer).not_to be_valid
    end
    it "tolerates empty fields but the date_answer" do
      answer = build(:answer, date_answer: "")
      expect(answer).not_to be_valid
    end
  end
end
