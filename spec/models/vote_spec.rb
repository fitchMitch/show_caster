# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  poll_id    :integer
#  answer_id  :integer
#  user_id    :integer
#  type       :string
#  comment    :string
#  vote_label :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Vote, type: :model do
  context "validations" do
    let(:vote) {FactoryBot.build(:vote_opinion)}
    subject { vote }

    it { should belong_to(:poll)}
    it { should belong_to(:answer)}
    it { should belong_to(:user)}

    it { should validate_presence_of (:user) }
    it { should validate_presence_of (:answer) }
  end

  context  "Persistance (opinion)" do
    let!(:symfields) { %i(vote_label comment) }
    let!(:valid_attributes_opinion) { build(:vote_opinion).attributes}
    let!(:vote_op){create(:vote_opinion, valid_attributes_opinion)}

    it "when done through factory should be ok" do
      symfields.each do |s_field|
        expect(vote_op.send(s_field)).to be == valid_attributes_opinion[s_field.to_s]
      end
    end
  end

  context "Persistance (date)" do
    let(:symfields) { %i(vote_label comment ) }
    let!(:valid_attributes_date) { build(:vote_date).attributes}
    let(:vote_da){create(:vote_date, valid_attributes_date)}

    it "when done through factory should be ok" do
      symfields.each do |s_field|
        expect(vote_da.send(s_field)).to be == valid_attributes_date[s_field.to_s]
      end
    end
  end

  context "with invalid attributes" do
    let!(:invalid_poll_attribute) { FactoryBot.build(:vote_date, poll_id: nil).attributes}
    let!(:invalid_user_attribute) { FactoryBot.build(:vote_date, user_id: nil).attributes}
    it "tolerates empty fields but the poll_id" do
      vote = build(:vote, invalid_poll_attribute)
      expect(vote).not_to be_valid
    end
    it "tolerates empty fields but the user_id" do
      vote = build(:vote, invalid_user_attribute)
      expect(vote).not_to be_valid
    end
  end
end
