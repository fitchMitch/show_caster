# == Schema Information
#
# Table name: coaches
#
#  id            :integer          not null, primary key
#  firstname     :string
#  lastname      :string
#  email         :string
#  cell_phone_nr :string
#  note          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Coach, type: :model do
  context 'with valid attributes' do
    # create(:user,:admin,:registered )
    let!(:existing_coach) { create(:coach) }
    let!(:valid_attributes) do
      { firstname: 'eric',
        lastname: 'bicon',
        email: 'gogo@lele.fr',
        cell_phone_nr: '0123456789',
        note: "a note"
      }
    end

    it { should validate_presence_of :firstname }
    it { should validate_length_of(:firstname).is_at_least(2) }
    it { should validate_length_of(:firstname).is_at_most(50) }
    it { should validate_presence_of :lastname }
    it { should validate_length_of(:lastname).is_at_least(2) }
    it { should validate_length_of(:lastname).is_at_most(50) }


    it { should allow_value('eric').for(:firstname) }
    it { should allow_value('BICONE').for(:lastname) }
    it { should allow_value('gogo@lele.fr').for(:email) }

    describe 'Persistance' do
      it 'should be persisted - factory validation' do
        coach = create(:coach, valid_attributes)

        expect(coach.firstname).to eq(valid_attributes[:firstname])
        expect(coach.lastname).to eq(valid_attributes[:lastname].upcase)
        expect(coach.email).to eq(valid_attributes[:email])
        expect(coach.cell_phone_nr).to eq('01 23 45 67 89')
      end
    end
  end

  context 'with invalid email attributes' do
    it { should_not allow_value('gog.o@lelefr').for :email }
  end
end
