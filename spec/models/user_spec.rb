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
        status: 'registered'
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

  describe '.active_admins' do
    let!(:admin) { create(:user, :registered) }
    let!(:admin_2) { create(:user, :registered) }
    let!(:user) { create(:user, :invited, :admin_com) }
    let!(:user_ex_admin) { create(:user, :archived) }
    it { expect(User.active_admins.count).to eq(2) }
  end

  describe '#is_commontator' do
    it 'should always be true' do
      expect(subject.is_commontator).to be(true)
    end
  end

  describe '#update_status' do
    describe 'with no parameters or cell_phone_nr' do
      let(:invited) { create(:user, :invited) }
      let(:params_with_phone) { {cell_phone_nr: '1234567890'}}

      it {expect(invited.update_status({}).status).to eq('missing_phone_nr')}
      it {expect(invited.update_status(params_with_phone).status).to eq('registered_with_no_pic')}
    end
    describe 'with no parameters nor cell_phone_nr' do
      let(:user_with_no_phone) { create(:user, :missing_phone_nr) }
      let(:params_with_phone) { {cell_phone_nr: '1234567890'}}

      it {expect(user_with_no_phone.update_status({}).status).to eq('missing_phone_nr')}
      it {expect(user_with_no_phone.update_status(params_with_phone).status).to eq('registered_with_no_pic')}
    end
    describe 'gets registered when all parameters are ok' do
      let(:registered_with_no_pic) { create(:user, :registered_with_no_pic) }
      it {expect(registered_with_no_pic.update_status({}).status).to eq('registered_with_no_pic')}
      describe 'with_picture' do
        before do
          allow(registered_with_no_pic).to receive(:has_downloaded_his_picture?).and_return true
        end
        it {expect(registered_with_no_pic.update_status({}).status).to eq('registered')}
      end
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

  describe '#send_promotion_mail' do
    let(:user) { create(:user, :registered) }
    let(:p_mail) { double('p_mail') }
    let(:deliver_now) { double('dlvr_now') }
    let(:a_mail) { double('a_mail') }
    let(:changes) { double('changes') }
    before do
      allow(UserMailer).to receive(:send_promotion_mail).with(user, changes) do
        p_mail
      end
      allow(p_mail).to receive(:deliver_now) { a_mail }
    end
    it 'should deliver mail' do
      expect(user.send_promotion_mail(changes)).to eq a_mail
    end
  end

  describe '#restricted_statuses' do
    context 'user is archived' do
      let(:user) { create(:user, :archived) }
      it 'should allow promotion to be registered or archived' do
        expect(user.restricted_statuses).to eq(%w[missing_phone_nr archived])
      end
    end
    context 'user is not archived' do
      let(:status) { %i[invited registered].sample }
      let(:user) { create(:user, status) }
      it 'should allow promotion to be original status or archived' do
        expect(user.restricted_statuses).to eq([status.to_s, 'archived'])
      end
    end
  end

  describe '#protected format_fields' do
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

  describe '#get_committee_changes' do
    let(:first_tag_list) { ['show', 'communication', 'psychokiller'] } # old_user
    let(:second_tag_list) { ['kiss', 'communication', 'psychokiller', 'management'] }
    let(:user) { build(:user) }
    before :each do
      allow(user).to receive(:committee_list) { second_tag_list }
    end
    it 'it should show the gained committees' do
      expect(user.get_committee_changes(first_tag_list)[:gained_committees]).to eq(['kiss', 'management'])
    end
    it 'it should show lost committees' do
      expect(user.get_committee_changes(first_tag_list)[:lost_committees]).to eq(['show'])
    end
    it 'it should set the changed boolean to true' do
      expect(user.get_committee_changes(first_tag_list)[:changed]).to be(true)
    end
  end

  describe '#inform_promoted_person' do
    let(:user) { build(:user, :registered, :player) }
    let(:player) { build(:user, :registered, :player) }
    let(:player2) { build(:user, :registered, :player) }
    let(:admin_com) { build(:user, :registered, :admin_com) }
    let(:admin) { build(:user, :registered, :admin) }
    let(:current_user) { build(:user, :registered, :admin) }
    let(:committee_changes) do
      {
        lost_committees: ['lost'],
        gained_committees: ['gained'],
        changed: true
      }
    end
    let(:committee_no_change) do
      {
        lost_committees: [],
        gained_committees: [],
        changed: false
      }
    end
    context 'when current_user curates himself' do
      it 'should return nothing' do
        expect(user.inform_promoted_person(user, admin, [])).to eq('users.updated')
      end
      it 'it should not send any mail' do
        expect(user).not_to receive(:send_promotion_mail)
        user.inform_promoted_person(user, admin, [])
      end
    end

    context 'when promotion is to be announced ' do
      before do
        allow_any_instance_of(User).to receive(:promotions_to_mute) { false }
      end
      context 'and when there is a committee change and a role change' do
        before :each do
          allow(
            admin_com
          ).to receive(:get_committee_changes) { committee_changes }
        end
        it 'it shall be told to the user' do
          allow(admin_com).to receive(:send_promotion_mail).with(
            committee_changes.merge(role: admin_com.role)
          ) { nil }
          expect(
            admin_com.inform_promoted_person(current_user, player, [])
          ).to eq('users.promoted')
        end
        it 'it shall send a promotion mail with committee name' do
          expect(admin_com).to receive(:send_promotion_mail).with(
            committee_changes.merge(role: admin_com.role)
          ) { nil }
          admin_com.inform_promoted_person(current_user, player, [])
        end
      end
      context 'and when there is committee change, but unchanged roles' do
        before :each do
          allow(
            player2
          ).to receive(:get_committee_changes) { committee_changes }
        end
        it 'it shall be told to the user' do
          allow(player2).to receive(:send_promotion_mail).with(
            committee_changes
          ) { nil }
          expect(
            player2.inform_promoted_person(current_user, player, [])
          ).to eq('users.promoted')
        end
        it 'it shall send a promotion mail with committee name' do
          expect(player2).to receive(:send_promotion_mail).with(
            committee_changes
          ) { nil }
          player2.inform_promoted_person(current_user, player, [])
        end
      end
    end

    context 'when promotion is to be muted ' do
      before do
        allow_any_instance_of(User).to receive(:promotions_to_mute) { true }
      end
      context 'and when there is a committee change' do
        before :each do
          allow(
            user
          ).to receive(:get_committee_changes) { committee_changes }
        end
        it 'it shall be told to the user' do
          allow(user).to receive(:send_promotion_mail).with(
            committee_changes
          ) { nil }
          expect(
            user.inform_promoted_person(current_user, player2, [])
          ).to eq('users.promoted')
        end
        it 'it shall send a promotion mail with committee name' do
          expect(user).to receive(:send_promotion_mail).with(
            committee_changes
          ) { nil }
          user.inform_promoted_person(current_user, player2, [])
        end
      end
      context 'and when there is NO committee change' do
        before :each do
          allow(
            user
          ).to receive(:get_committee_changes) { committee_no_change }
        end
        it 'it shall be told to the user' do
          expect(
            user.inform_promoted_person(current_user, player, [])
          ).to eq('users.promoted_muted')
        end
        it 'it shall send a promotion mail with committee name' do
          expect(user).not_to receive(:send_promotion_mail) { nil }
          user.inform_promoted_person(current_user, player, [])
        end
      end
    end
  end

  describe '#promotions_to_mute' do
    let(:admin) { build(:user, :registered, :admin) }
    let(:user_com) { build(:user, :registered, :admin_com) }
    let(:player) { build(:user, :registered, :player) }
    context 'it shall be muted' do
      let(:old_user) { build(:user, :registered, :admin) }
      it 'when downgrading' do
        expect(
          user_com.send(:promotions_to_mute, old_user)
        ).to be true
      end
    end
    context 'it shall not be muted ' do
      let(:old_user) { build(:user, :archived, :admin) }
      it ' when previously archived' do
        expect(
          user_com.send(:promotions_to_mute, old_user)
        ).to be false
      end
    end
    context 'when it shall not be muted' do
      let(:old_user) { build(:user, :registered, :player) }
      it 'should return true to mute' do
        expect(
          user_com.send(:promotions_to_mute, old_user)
        ).to be false
      end
    end
  end

  describe '#flash_promotion_with' do
    let(:player) { build(:user, :registered, :player) }
    it 'should announce no message for \'promoted\' player' do
      expect(
        player.send(:flash_promotion_with, false)
      ).to eq('users.promoted_muted')
    end
    it 'should return a message announcing the promotion email' do
      expect(
        player.send(:flash_promotion_with, true)
      ).to eq('users.promoted')
    end
  end

  describe '#more_privileges?' do
    let(:user) { create(:user, :admin_com) }
    context 'when stronger ' do
      let(:o_user) { create(:user, :player) }
      it 'user is stronger' do
        expect(user.send(:more_privileges?, o_user)).to be true
      end
    end
    context 'when weaker ' do
      let(:o_user) { create(:user, :admin) }
      it 'user is stronger' do
        expect(user.send(:more_privileges?, o_user)).to be false
      end
    end
  end
end
