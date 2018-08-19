# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string           not null
#  lastname        :string           not null
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default("setup")
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default("player")
#  token           :string
#  refresh_token   :string
#  expires_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  color           :string
#  bio             :text
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context "with valid attributes" do
    # create(:user,:admin,:registered )
    let!(:existing_user) { create(:user, :admin, :registered)}
    let!(:valid_attributes) {
      { firstname: "eric",
      lastname: "bicon",
      email: "gogo@lele.fr",
      cell_phone_nr: "0123456789",
      uid: "1a",
      status: 'googled'
      }
    }

    it { should validate_presence_of (:firstname) }
    it { should validate_length_of(:firstname).is_at_least(2) }
    it { should validate_length_of(:firstname).is_at_most(50) }
    #
    it { should validate_presence_of (:lastname) }
    it { should validate_length_of(:lastname).is_at_least(2) }
    it { should validate_length_of(:lastname).is_at_most(50) }

    it { should validate_presence_of (:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    # it { should validate_uniqueness_of(:email)}

    # it { should validate_uniqueness_of(:uid)}

    it { should allow_value("eric").for(:firstname)}
    it { should allow_value("BICONE").for(:lastname)}
    it { should allow_value("gogo@lele.fr").for(:email)}

    describe "Persistance" do
      it "should be persisted - factory validation" do
        user = create(:user, valid_attributes)

        expect(user.firstname).to eq(valid_attributes[:firstname])
        expect(user.lastname).to eq((valid_attributes[:lastname]).upcase)
        expect(user.email).to eq(valid_attributes[:email])
        expect(user.cell_phone_nr).to eq("01 23 45 67 89")
      end
    end
  end

  context "with invalid email attributes" do
      it { should_not allow_value("gog.o@lelefr").for (:email)}
  end
end
