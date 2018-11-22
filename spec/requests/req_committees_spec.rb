require 'rails_helper'

RSpec.describe "Committees", type: :request do
  let(:valid_attributes) { { name: 'culture' } }
  let(:invalid_attributes_mission_only) { { mission: 'promouvoir la culture' } }
  let(:invalid_attributes) { { name: 'a' * 46 } }
  let!(:admin) { create(:user, :admin, :registered) }

  context '/ As logged as admin,' do
    before do
      request_log_in(admin)
    end

    describe 'GET #index' do
      it 'renders committees index' do
        Committee.create! valid_attributes
        get '/committees'
        expect(response).to render_template(:index)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Committee' do
          expect {
            post '/committees', params: { committee: valid_attributes }
          }.to change(Committee, :count).by(1)
        end

        it 'assigns a newly created committee as @committee ' \
           'and formats cell_phone_nr' do
          post '/committees', params: { committee: valid_attributes }
          expect(Committee.last.name).to eq(valid_attributes[:name])
        end

        it 'redirects to the created committee' do
          post '/committees', params: { committee: valid_attributes }
          expect(response).to redirect_to committees_path
        end
      end

      context 'with invalid params' do
        it "re-renders the 'new' template" do
          post '/committees', params: { committee: invalid_attributes_mission_only }
          expect(response).to render_template :new
        end

        it "doesn't persist committee" do
          expect {
            post '/committees', params: { committee: invalid_attributes_mission_only }
          }.to change(Committee, :count).by(0)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      before :each do
        request_log_in(admin)
      end
      let(:new_attributes_name) {
        { name: 'culture', mission: 'divertir'}
      }
      let(:new_attributes) {
        { name: 'culture et tradition', mission: 'divertir et amuser' }
      }
      let(:valid_session) { request_log_in(admin) }
      let(:committee) { create(:committee) }

      it 'updates the requested name with a new name' do
        url = "/committees/#{committee.to_param}"
        put url, params: { id: committee.id, committee: new_attributes_name }
        committee.reload
        expect(committee).to have_attributes(
          name: new_attributes_name[:name],
          mission: new_attributes_name[:mission]
        )
      end

      it 'updates the requested committee' do
        url = "/committees/#{committee.to_param}"
        put url, params: { id: committee.id, committee: new_attributes }
        committee.reload
        expect(committee).to have_attributes(name: new_attributes[:name])
        expect(committee).to have_attributes(mission: new_attributes[:mission])
      end

      it 'redirects to the index page' do
        url = "/committees/#{committee.to_param}"
        put url, params: { id: committee.id, committee: new_attributes }
        expect(response).to redirect_to committees_path
      end
    end

    context 'with invalid params' do
      before :each do
        admin = create(:user, :admin, :registered)
        request_log_in(admin)
      end
      let(:committee) { create(:committee) }

      it 'assigns the committee as @committee' do
        url = "/committees/#{committee.to_param}"
        put url, params: { id: committee.id, committee: invalid_attributes }
        committee.reload
        expect(committee.name).not_to eq(invalid_attributes[:name])
      end

      it "re-renders the 'edit' template" do
        url = "/committees/#{committee.to_param}"
        put url, params: { id: committee.id, committee: invalid_attributes }
        expect(response).to render_template :edit
      end
    end
  end
  describe '#DESTROY' do
    let!(:committee) { create(:committee) }
    let!(:url) { "/committees/#{committee.to_param}" }
    context 'when there are two committees' do
      before do
        request_log_in(admin)
      end
      it 'should destroy one committee' do
        expect do
          delete url, params: { id: committee.id }
        end.to change(Committee, :count).by(-1)
      end
    end
    context 'when there is a single committee' do
      before do
        request_log_in(admin)
        Committee.delete_all
      end
      it 'should destroy one committee' do
        create(:committee)
        expect do
          delete url, params: { id: committee.id }
        end.to change(Committee, :count).by(0)
      end
    end
  end
end
