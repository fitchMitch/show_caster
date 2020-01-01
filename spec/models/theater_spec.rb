require 'rails_helper'

RSpec.describe Theater, type: :model do
  context 'with valid attributes' do
    let(:valid_attributes) do
      {
        theater_name: 'à la belle Etoile',
        location: '12 de la rue',
        manager: 'M.Jules',
        manager_phone: '0123456789'
      }
    end

    it { should validate_presence_of(:theater_name) }
    it { should validate_length_of(:theater_name).is_at_least(2) }
    it { should validate_length_of(:theater_name).is_at_most(40) }

    describe 'Persistance' do
      it 'should be verified : factory validation' do
        theater = create(:theater, valid_attributes)

        expect(theater.theater_name).to eq(
          valid_attributes[:theater_name]
        )
        expect(theater.location).to eq(valid_attributes[:location])
        expect(theater.manager).to eq(valid_attributes[:manager])
        expect(theater.manager_phone).to eq('01 23 45 67 89')
      end
    end
  end

  context 'with invalid attributes' do
    it 'tolerates empty fields but the name' do
      theater = build(:theater, theater_name: '')
      expect(theater).not_to be_valid
      other_theater = build(
        :other_theater,
        manager: '',
        manager_phone: '',
        location: ''
      )
      expect(other_theater).to be_valid
    end
  end

  describe '#formatting' do
    let(:theater) do
      build(
        :theater,
        manager_phone: '0123456789',
        theater_name: 'lys'
      )
    end
    it 'should format phone number' do
      theater.save
      expect(theater.manager_phone).to eq('01 23 45 67 89')
    end
    it 'should format theater name' do
      theater.save
      expect(theater.theater_name).to eq('lys')
    end
  end
end
