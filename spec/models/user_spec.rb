# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string           not null
#  lastname        :string           not null
#  email           :string
#  last_sign_in_at :datetime
#  status          :integer          default('setup')
#  provider        :string
#  uid             :string
#  address         :string
#  cell_phone_nr   :string
#  photo_url       :string
#  role            :integer          default('player')
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
  context 'with valid attributes' do
    let!(:existing_user) { create(:user, :admin, :registered) }
    let!(:valid_attributes) do
      {
        firstname: 'eric',
        lastname: 'bicon',
        email: 'gogo@lele.fr',
        cell_phone_nr: '0123456789',
        uid: '1a',
        status: 'googled'
      }
    end

    it { should validate_presence_of(:firstname) }
    it { should validate_length_of(:firstname).is_at_least(2) }
    it { should validate_length_of(:firstname).is_at_most(50) }

    it { should validate_presence_of(:lastname) }
    it { should validate_length_of(:lastname).is_at_least(2) }
    it { should validate_length_of(:lastname).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }

    it { should allow_value('eric').for(:firstname) }
    it { should allow_value('BICONE').for(:lastname) }
    it { should allow_value('gogo@lele.fr').for(:email) }

    describe 'Persistance' do
      it 'should be persisted - factory validation' do
        user = create(:user, valid_attributes)

        expect(user.firstname).to eq(valid_attributes[:firstname])
        expect(user.lastname).to eq(valid_attributes[:lastname].upcase)
        expect(user.email).to eq(valid_attributes[:email])
        expect(user.cell_phone_nr).to eq('01 23 45 67 89')
      end
    end
  end

  context 'with invalid email attributes' do
    it { should_not allow_value('gog.o@lelefr').for(:email) }
  end

  describe '#is_commontator' do
    it 'should always be true' do
      expect(subject.is_commontator).to be(true)
    end
  end

  describe '#welcome_mail' do
    let(:user) { create(:user, :registered) }
    let(:w_mail) { double('w_mail') }
    let(:deliver_now) { double('dlvr_now') }
    let(:a_mail) { double('a_mail') }
    before do
      allow(UserMailer).to receive(:welcome_mail).with(user) do
        w_mail
      end
      allow(w_mail).to receive(:deliver_now) { a_mail }
    end
    it 'should deliver mail' do
      expect(user.welcome_mail).to eq a_mail
    end
  end

  describe '#promoted_mail' do
    let(:user) { create(:user, :registered) }
    let(:p_mail) { double('p_mail') }
    let(:deliver_now) { double('dlvr_now') }
    let(:a_mail) { double('a_mail') }
    before do
      allow(UserMailer).to receive(:promoted_mail).with(user) do
        p_mail
      end
      allow(p_mail).to receive(:deliver_now) { a_mail }
    end
    it 'should deliver mail' do
      expect(user.promoted_mail).to eq a_mail
    end
  end

  describe '#restricted_statuses' do
    context 'user is archived' do
      let(:user) { create(:user, :archived) }
      it 'should allow promotion to be setup or archived' do
        expect(user.restricted_statuses).to eq(%w[setup archived])
      end
    end
    context 'user is not archived' do
      let(:status) { %i[setup invited googled registered].sample }
      let(:user) { create(:user, status) }
      it 'should allow promotion to be original status or archived' do
        expect(user.restricted_statuses).to eq([status.to_s, 'archived'])
      end
    end
  end

  describe 'protected format_fields' do
    let(:user) do create(
      :user,
      email: 'ASHTON.KUTCHER@hollYood.fr',
      lastname: 'KutcHER',
      role: nil,
      color: nil,
      cell_phone_nr: '0123456789'
    )
    end
    let!(:pick_color) { double('pick_color') }

    before(:each) do
      allow(Users::Formating).to receive(:pick_color).and_return(pick_color)
      allow_any_instance_of(Users::Formating).to receive(:pick_color).and_return(pick_color)
      expect user.send(:format_fields)
    end
    it 'should format the email downcase' do
      expect(user.email).to eq('ashton.kutcher@hollyood.fr')
    end
    it 'should format the lastname upcase' do
      expect(user.lastname).to eq('KUTCHER')
    end
    it 'should have a player role when nothing decided yet' do
      expect(user.role).to eq('player')
    end
    it 'should format the email downcase' do
      expect(user.color).to eq(pick_color.to_s)
    end
    it 'should format the email downcase' do
      expect(user.cell_phone_nr).to eq('01 23 45 67 89')
    end
  end
end
