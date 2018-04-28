require 'rails_helper'

RSpec.describe "Theaters", type: :request do
  let(:valid_attributes) { {theater_name: "A la belle Etoile"} }
  let(:invalid_attributes_address_only) { {location: 'xx, rue de Roquancourt PARIS 12'} }
  let(:invalid_attributes) { {theater_name: 'a' * 41} }
  let!(:admin) { create(:user,:admin,:registered)}

  context "/ As logged as admin," do
    before do
      request_log_in(admin)
    end

    describe "GET #index" do
      it "renders theaters index" do
        theater = Theater.create! valid_attributes
        get '/theaters'
        expect(response).to render_template (:index)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Theater" do
          expect {
            post '/theaters', params: {theater: valid_attributes}
          }.to change(Theater, :count).by(1)
        end

        it "assigns a newly created theater as @theater and formats cell_phone_nr" do
          post '/theaters', params: {theater: valid_attributes}
          expect(Theater.last.theater_name).to eq("A la belle Etoile")
        end

        it "redirects to the created theater" do
          post '/theaters', params: {theater: valid_attributes}
          t = Theater.find_by(theater_name: valid_attributes[:theater_name])
          expect(response).to redirect_to theaters_path
        end
      end

      context "with invalid params" do
        it "re-renders the 'new' template" do
          post '/theaters', params: {theater: invalid_attributes_address_only}
          expect(response).to render_template :new
        end

        it "doesn't persist theater" do
          expect {
            post '/theaters', params: {theater: invalid_attributes_address_only}
          }.to change(Theater, :count).by(0)
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
      let(:new_attributes_theater_name) {
        {theater_name: "Sous les ponts"}
      }
      let(:new_attributes) {
        { location: 'xx, rue de Lichtenstein PARIS 12',
          manager: "Tenardier",
          manager_phone: "0666666666"
        }
      }
      let(:valid_session) { request_log_in( admin ) }
      let(:theater) { create(:theater) }

      it "updates the requested theater_name with a new theater_name" do
        url = "/theaters/#{theater.to_param}"
        put url , params:{ id: theater.id, theater:new_attributes_theater_name }
        theater.reload
        expect(theater).to have_attributes(
          theater_name: new_attributes_theater_name[:theater_name]
        )
      end

      it "updates the requested theater" do
        url = "/theaters/#{theater.to_param}"
        put url , params:{ id: theater.id, theater: new_attributes}
        theater.reload
        expect(theater).to have_attributes( manager_phone: '06 66 66 66 66' )
        expect(theater).to have_attributes( manager: new_attributes[:manager])
        expect(theater).to have_attributes( location: new_attributes[:location] )
      end

      it "redirects to the users page" do
        url = "/theaters/#{theater.to_param}"
        put url , params:{ id: theater.id, theater: new_attributes }
        expect(response).to redirect_to theaters_path
      end
    end

    context "with invalid params" do
      before :each do
        admin = create(:user, :admin, :registered)
        request_log_in(admin)
      end
      let(:theater) { create(:theater) }

      it "assigns the theater as @theater" do
        url = "/theaters/#{theater.to_param}"
        put url , params:{ id: theater.id, theater: invalid_attributes }
        theater.reload
        expect(theater.theater_name).not_to eq(invalid_attributes[:theater_name])
      end

      it "re-renders the 'edit' template" do
        url = "/theaters/#{theater.to_param}"
        put url, params:{ id: theater.id, theater: invalid_attributes }
        expect(response).to render_template :edit
      end
    end
  end






  # before :each do
  #   begin
  #     Devise
  #     sign_out :user
  #   rescue NameError
  #   end
  # end
  # describe "GET /theaters" do
  #   it "doesn't work unless signed_in" do
  #     get theaters_path
  #     expect(response).to have_http_status(302)
  #     # sign_in_as_a_valid_user
  #     # get theaters_path
  #     # expect(response).to have_http_status(200)
  #   end
  # end
end
