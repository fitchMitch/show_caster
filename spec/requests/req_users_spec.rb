require 'rails_helper'
# require 'vcr'

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
        request_log_in_admin
      end
      it 'renders users index' do
        get '/users/new'
        expect(response).to render_template(:new)
      end
    end
    describe 'NEW' do
      before :each do
        request_log_in_admin
      end
      it 'builds a new User' do
        user = User.new valid_attributes
        expect(user).to be_valid
        post '/users', params: { user: valid_attributes }
        expect(response).to redirect_to users_path
      end
    end
    describe 'EDIT' do
      it 'builds edits User' do
        admin = create(:user, :admin, :registered)
        request_log_in(admin)
        get edit_user_path(admin)
        expect(response).to render_template :complement
      end
    end
    describe 'POST #create' do
      context 'with valid params' do
        before :each do
          request_log_in_admin
        end
        it 'creates a new User' do
          user = User.new valid_attributes
          expect(user).to be_valid
          post '/users', params: { user: valid_attributes }
          expect(response).to redirect_to users_path
        end
      end
      context 'with invalid params' do
        before :each do
          request_log_in_admin
        end
        it 'fails to create a new User' do
          user = User.new invalid_attributes
          expect(user).not_to be_valid
          post '/users', params: { user: invalid_attributes }
          expect(response).to render_template(:new)
        end
      end
    end
    describe 'UPDATE' do
      context 'with valid params' do
        before :each do
          @admin = create(:user, :admin, :setup)
          request_log_in @admin
          @url = "/users/#{@admin.id}"
        end
        it 'is ok' do
          put @url, params: { id: @admin.id, user: new_valid_attributes }
          expect(response).to redirect_to users_path
        end
      end
      context 'with invalid params' do
        before :each do
          @admin = create(:user, :admin, :setup)
          request_log_in @admin
          @url = "/users/#{@admin.id}"
        end
        it 'fails to update user' do
          put @url, params: { id: @admin.id, user: invalid_attributes }
          expect(response).to render_template(:complement)
        end
      end
    end
  end

  describe '#promote' do
    let!(:user) { create(:user, :setup) }
    let!(:admin) { create(:user, :admin, :registered) }
    let(:current_user) { create(:user, :admin, :registered) }
    let(:old_user) { create(:user, :admin, :registered) }
    let!(:url) { "/users/#{user.id}/promote" }
    before :each do
      request_log_in admin
    end
    context 'user\'s update status is Nok' do
      before :each do
        allow_any_instance_of(User).to receive(:update) { false }
      end
      it 'should redirect to show' do
        patch url, { params: { user: { role: 'admin', status: :registered } } }
        expect(response).to render_template(:show)
      end
      it 'should redirect to show' do
        patch url, { params: { user: { role: 'admin', status: :registered } } }
        expect(flash[:alert]).to include(I18n.t('users.promoted_failed', name: user.full_name))
      end
    end
    context 'user\'s update status is ok' do
      let!(:message) { double('message') }
      before :each do
        allow(user).to receive(:inform_promoted_person) { message }
      end
      it 'should redirect to user\'s page when ok' do
        # expect(user).to receive(:inform_promoted_person).with(current_user, old_user)
        patch url, { params: { user: { role: 'admin', status: :registered } } }
        expect(response).to redirect_to user_path(user)
      end
      it 'should redirect to user\'s page when ok' do
        patch url, { params: { user: { role: 'admin', status: :registered } } }
        expect(flash[:notice]).to include(user.full_name)
      end
    end
  end

  describe '#invite' do
    let!(:admin) { create(:user, :admin, :registered) }
    let!(:url) { "/users/#{user.id}/invite" }
    let(:welcome_mail) { double('welcome_mail') }
    before :each do
      request_log_in admin
    end
    context 'user\'s update status is Nok' do
      let!(:user) { create(:user, :setup) }
      before :each do
        allow_any_instance_of(User).to receive(:update) { false }
        allow_any_instance_of(User).to receive(:welcome_mail) { welcome_mail }
      end
      it 'should redirect to user\'s page when Not ok' do
        patch url
        expect(response).to render_template(:show)
      end
    end
    context 'user\'s update status is ok' do
      let!(:user) { create(:user, :setup) }
      before :each do
        allow(user).to receive(:welcome_mail) { welcome_mail }
      end
      it 'should redirect to user\'s page when ok' do
        patch url, { params: { id: user.id, user: user.attributes } }
        expect(response).to redirect_to user_path(user)
      end
      it 'should redirect to user\'s page when ok' do
        patch url, { params: { id: user.id, user: user.attributes } }
        expect(flash[:notice]).to include(
          I18n.t(
            'users.invited',
            name: user.full_name
          )
        )
      end
    end
  end

  describe '#bio' do
    let(:user) { create(:user, :player, :registered, bio: 'test') }
    let(:admin) { create(:user, :admin, :registered) }
    let(:url) { "/users/#{user.id}/bio" }
    before :each do
      request_log_in admin
    end
    context 'user is defined and valid' do
      it 'should redirect to user\'s page when ok' do
        patch url, params: { id: user.id, user: user.attributes }
        expect(response).to redirect_to user_path(user)
      end
      it 'should update user\'s bio ' do
        patch url, params: { id: user.id, user: user.attributes }
        user.reload
        expect(user.bio).to eq 'test'
      end
    end
  end
 end
