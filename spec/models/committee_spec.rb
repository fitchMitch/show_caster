require 'rails_helper'

RSpec.describe Committee, type: :model do
  context 'with valid attributes' do
    let!(:valid_attributes) do
      {
        name: 'culture',
        mission: 'faire progresser la culture par les moyens idoines'
      }
    end

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_length_of(:name).is_at_most(45) }

    describe 'Persistance' do
      let!(:committee) do build(
        :committee,
        name: valid_attributes[:name],
        mission: valid_attributes[:mission]
        )
      end
      it 'should be verified : factory validation' do
        expect(committee.name).to eq(valid_attributes[:name])
        expect(committee.mission).to eq(valid_attributes[:mission])
      end
    end
  end

  context 'with invalid attributes' do
    it 'tolerates empty fields but the name' do
      committee = build(:committee, name: '')
      expect(committee).not_to be_valid
    end
  end

  describe '.allow_to_destroy?' do
    context 'when only one committee exists' do
      before do
        create(:committee)
      end
      it 'should not allow the only commitee to be destroyed' do
        expect(Committee.allow_to_destroy?).to be false
      end
    end
    context 'when serveral committees exist' do
      before do
        2.times { create(:committee) }
      end
      it 'should allow a commitee to be destroyed' do
        expect(Committee.allow_to_destroy?).to be true
      end
    end
  end

  describe '#redispatch_users' do
    let(:committee_one) { create(:committee) }
    let(:committee_two) { create(:committee) }
    before do
      committee_one.redispatch_users
    end
    it 'every user should be on the same committee' do
      expect(
        User.all.all? { |user| user.committee_id == committee_two.id }
      ).to be true
    end
  end
end
