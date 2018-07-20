# == Schema Information
#
# Table name: polls
#
#  id              :integer          not null, primary key
#  question        :string
#  expiration_date :date
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Poll, type: :model do
  it { should validate_presence_of (:expiration_date) }
  it { should validate_presence_of (:question) }
  it { should validate_length_of(:question).is_at_least(5) }
  it { should validate_length_of(:question).is_at_most(120) }
end

RSpec.describe PollOpinion, type: :model do
  context "with valid attributes" do
    let (:valid_attributes) {
      {
        question: "There Dude ?",
        expiration_date: Date.today.days_since(6),
        type: 'PollOpinion'
      }
    }
    it { should have_many(:answers) }
    describe "Persistance" do
      it "should be verified : factory validation" do
        poll = create(:poll, valid_attributes)

        expect(poll.question).to eq(valid_attributes[:question])
        expect(poll.expiration_date).to eq(valid_attributes[:expiration_date])
        expect(poll.type).to eq(valid_attributes[:type])
      end
    end
  end
end

RSpec.describe PollDate, type: :model do
  context "with valid attributes" do
    let (:valid_attributes) {
      {
        question: "When Dude ?",
        expiration_date: Date.today.days_since(6),
        type: 'PollDate'
      }
    }
    it { should have_many(:answers) }
    describe "Persistance" do
      it "should be verified : factory validation" do
        poll = create(:poll, valid_attributes)

        expect(poll.question).to eq(valid_attributes[:question])
        expect(poll.expiration_date).to eq(valid_attributes[:expiration_date])
        expect(poll.type).to eq(valid_attributes[:type])
      end
    end
  end
end
