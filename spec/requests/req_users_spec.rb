require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_attributes) do
    {
      firstname: 'eric',
      lastname: 'bicon',
      email: 'gogo@lele.fr',
      cell_phone_nr: '0163456789'
    }
  end
  let(:new_valid_attributes) do
    {
      firstname: 'Gelle',
      lastname: 'Lieffer',
      email: 'gaga@lele.fr',
      cell_phone_nr: '0123488789'
    }
  end
  let(:invalid_attributes) do
    {
      firstname: 'eric',
      lastname: 'bicon',
      email: 'gogo@lelefr',
      cell_phone_nr: '0123456789'
    }
  end
  context 'As logged as admin' do
    describe 'GET #index' do
      before :each do
        sign_in(create(:user, :admin, :registered))
      end
      it 'renders users index' do
        get '/users/new'
        expect(response).to render_template(:new)
      end
    end
    describe 'UPDATE' do
      context 'with valid params' do
        before :each do
          @admin = create(:user, :admin, :registered)
          sign_in @admin
          @url = "/users/#{@admin.id}"
        end
        it 'is ok' do
          put @url, params: { id: @admin.id, user: new_valid_attributes }
          expect(response).to redirect_to users_path
        end
      end
    end
  end

  describe '#promote' do
    # let!(:user) { create(:user, :setup) }
    # let!(:admin) { create(:user, :admin, :registered) }
    # let(:current_user) { create(:user, :admin, :registered) }
    # let(:old_user) { create(:user, :admin, :registered) }
    # let(:valid_updates) do
    #   { role: 'admin', status: :registered }
    # end
    # let!(:url) { "/users/#{user.id}/promote" }
    # before :each do
    #   sign_in admin
    # end
    # context 'user\'s update status is Nok' do
    #   before :each do
    #     allow_any_instance_of(User).to receive(:update) { false }
    #   end
    #   it 'should redirect to show' do
    #     patch url, { params: { user: valid_updates } }
    #     expect(response).to render_template(:show)
    #   end
    #   it 'should redirect to show' do
    #     patch url, { params: { user: valid_updates } }
    #     expect(flash[:alert]).to include(
    #       I18n.t('users.promoted_failed', name: user.full_name)
    #     )
    #   end
    # end
    # context 'user\'s update status is ok' do
    #   before :each do
    #     allow_any_instance_of(User).to receive(
    #       :inform_promoted_person
    #     ) { 'users.updated' }
    #     patch url, { params: { user: valid_updates } }
    #   end
    #   it 'should redirect to user\'s page when ok' do
    #     expect(response).to redirect_to user_path(user)
    #   end
    #   it 'should redirect to user\'s page when ok' do
    #     expect(flash[:notice]).to include(I18n.t('users.updated'))
    #   end
    # end
  end

  # describe '#invite' do
  #   let!(:admin) { create(:user, :admin, :registered) }
  #   let!(:url) { "/users/#{user.id}/invite" }
  #   let(:welcome_mail) { double('welcome_mail') }
  #   before :each do
  #     sign_in admin
  #   end
  #   context 'user\'s update status is ok' do
  #     let!(:user) { create(:user, :setup) }
  #     before :each do
  #       allow(user).to receive(:welcome_mail) { welcome_mail }
  #     end
  #     it 'should redirect to user\'s page when ok' do
  #       patch url, { params: { id: user.id, user: user.attributes } }
  #       expect(response).to redirect_to user_path(user)
  #     end
  #     it 'should redirect to user\'s page when ok' do
  #       patch url, { params: { id: user.id, user: user.attributes } }
  #       expect(flash[:notice]).to include(
  #         I18n.t(
  #           'users.invited',
  #           name: user.full_name
  #         )
  #       )
  #     end
  #   end
  # end

  describe '#bio' do
    let(:user) { create(:user, :player, :registered, bio: 'test') }
    let(:admin) { create(:user, :admin, :registered) }
    let(:url) { "/users/#{user.id}/bio" }
    before :each do
      sign_in admin
    end
    context 'user is defined and valid' do
      it 'should redirect to user\'s page when ok' do
        patch url, params: { id: user.id, user: user.attributes }
        expect(response).to redirect_to user_path(user)
      end
      it 'should update user\'s bio ' do
        patch url, params: { id: user.id, user: user.attributes }
        expect(user.reload.bio).to eq 'test'
      end
    end
  end
 end
