require 'rails_helper'

RSpec.describe 'AnnouncesController', type: :request do
  let(:valid_attributes) do
    {
      title: "A la belle Etoile",
      body: "*" * 11,
      time_start: Time.zone.now + 5.days,
      time_end: Time.zone.now + 6.days
    }
  end
  let(:invalid_attributes_body_only) { { body: 'xx, rue'} }
  let(:invalid_attributes) { { title: 'a' * 41} }
  let!(:admin) { create(:user,:admin,:registered) }

  context "/ As logged as admin," do
    before do
      request_log_in(admin)
    end

    describe "GET #index" do
      it "renders announces index" do
        announce = Announce.create! valid_attributes
        get '/announces'
        expect(response).to render_template (:index)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Announce" do
          expect {
            post '/announces', params: { announce: valid_attributes }
          }.to change(Announce, :count).by(1)
        end

        it "assigns a newly created announce as @announce and formats cell_phone_nr" do
          post '/announces', params: { announce: valid_attributes }
          expect(Announce.last.title).to eq("A la belle Etoile")
        end

        it "redirects to the created announce" do
          post '/announces', params: { announce: valid_attributes }
          # t = Announce.find_by(title: valid_attributes[:title])
          expect(response).to redirect_to announces_path
        end
      end

      context "with invalid params" do
        it "re-renders the 'new' template" do
          post '/announces', params: { announce: invalid_attributes_body_only }
          expect(response).to render_template :new
        end

        it "doesn't persist announce" do
          expect {
            post '/announces', params: { announce: invalid_attributes_body_only }
          }.to change(Announce, :count).by(0)
        end
      end
    end
  end


  describe "PUT #update" do
    context "with valid params" do
      before :each do
        # admin = create(:user, :admin, :registered)
        request_log_in(admin)
      end
      let(:new_attributes_title) {
        { title: "SOUS LES PONTS"}
      }
      let(:new_attributes) {
        { body: 'xx, rue de Lichtenstein PARIS 12',
          title: "Tenardier"
        }
      }
      let(:valid_session) { request_log_in( admin ) }
      let(:announce) { create(:announce) }

      it "updates the requested title with a new title" do
        url = "/announces/#{announce.to_param}"
        put url, params:{ id: announce.id, announce:new_attributes_title }
        announce.reload
        expect(announce).to have_attributes(
          title: new_attributes_title[:title]
        )
      end

      it "updates the requested announce" do
        url = "/announces/#{announce.to_param}"
        put url, params:{ id: announce.id, announce: new_attributes }
        announce.reload
        expect(announce).to have_attributes( body: new_attributes[:body] )
      end

      it "redirects to the users page" do
        url = "/announces/#{announce.to_param}"
        put url, params:{ id: announce.id, announce: new_attributes }
        expect(response).to redirect_to announces_path
      end
    end

    context "with invalid params" do
      before :each do
        admin = create(:user, :admin, :registered)
        request_log_in(admin)
      end
      let(:announce) { create(:announce) }

      it "assigns the announce as @announce" do
        url = "/announces/#{announce.to_param}"
        put url, params:{ id: announce.id, announce: invalid_attributes }
        announce.reload
        expect(announce.title).not_to eq(invalid_attributes[:title])
      end

      it "re-renders the 'edit' template" do
        url = "/announces/#{announce.to_param}"
        put url, params:{ id: announce.id, announce: invalid_attributes }
        expect(response).to render_template :edit
      end
    end
  end
end
