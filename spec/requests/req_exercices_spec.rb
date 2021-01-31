require 'rails_helper'

RSpec.describe "Exercices", type: :request do
  let(:valid_attributes) do
    {
      title: "A la belle Etoile",
      instructions: "There shall be"
    }
  end
  # let(:invalid_attributes_address_only) { { location: 'xx, rue de Roquancourt PARIS 12' } }
  let(:invalid_attributes) { { title: 'a' * 41 } }
  let!(:admin) { create(:user, :admin, :registered) }


  context "/ As logged as admin," do
    before do
      sign_in admin
    end

    describe "GET #index" do
      it "renders exercices index" do
        Exercice.create! valid_attributes
        get '/exercices'
        expect(response).to render_template(:index)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Exercice" do
          expect {
            post '/exercices', params: { exercice: valid_attributes }
          }.to change(Exercice, :count).by(1)
        end

        it "assigns a newly created exercice as @exercice and formats cell_phone_nr" do
          post '/exercices', params: { exercice: valid_attributes }
          expect(Exercice.last.title).to eq(valid_attributes[:title])
        end

        it "redirects to the created exercice" do
          post '/exercices', params: { exercice: valid_attributes }
          expect(response).to redirect_to exercices_path
        end
      end

      context "with invalid params" do
        it "re-renders the 'new' template" do
          post '/exercices', params: { exercice: invalid_attributes }
          expect(response).to render_template :new
        end

        it "doesn't persist exercice" do
          expect {
            post '/exercices', params: { exercice: invalid_attributes }
          }.to change(Exercice, :count).by(0)
        end
      end
    end

  end


  describe "PUT #update" do
    context "with valid params" do
      before :each do
        # admin = create(:user, :admin, :registered)
        sign_in(admin)
      end
      let(:new_attributes_title) {
        { title: "SOUS LES PONTS"}
      }
      let(:valid_session) { sign_in( admin ) }
      let(:exercice) { create(:exercice) }

      it "updates the requested title with a new title" do
        url = "/exercices/#{exercice.to_param}"
        put url, params: { id: exercice.id, exercice: new_attributes_title }
        exercice.reload
        expect(exercice).to have_attributes(
          title: new_attributes_title[:title]
        )
      end

      it "redirects to the exercices page" do
        url = "/exercices/#{exercice.to_param}"
        put url, params:{ id: exercice.id, exercice: new_attributes_title }
        expect(response).to redirect_to exercices_path
      end
    end

    context "with invalid params" do
      before :each do
        admin = create(:user, :admin, :registered)
        sign_in(admin)
      end
      let(:exercice) { create(:exercice) }

      it "assigns the exercice as @exercice" do
        url = "/exercices/#{exercice.to_param}"
        put url, params:{ id: exercice.id, exercice: invalid_attributes }
        exercice.reload
        expect(exercice.title).not_to eq(invalid_attributes[:title])
      end

      it "re-renders the 'edit' template" do
        url = "/exercices/#{exercice.to_param}"
        put url, params:{ id: exercice.id, exercice: invalid_attributes }
        expect(response).to render_template :edit
      end
    end
  end

  describe "#destroyed" do
    let!(:exercice) { create(:exercice) }
    let!(:exercice2) { create(:exercice) }
    let(:valid_session) { sign_in( admin ) }
    let(:url) { "/exercices/#{exercice.to_param}" }
    context 'with valid DB' do
      before :each do
        sign_in(admin)
      end
      it "destroys the requested exercice " do
        expect {
          delete url, params: { id: exercice.to_param }
        }.to change(Exercice, :count).by(-1)
      end

      it "redirects to the exercices page" do
        delete url, params: { id: exercice.to_param }
        expect(response).to redirect_to exercices_path
      end
    end
    context 'with INvalid DB' do
      before :each do
        sign_in(admin)
        allow_any_instance_of(Exercice).to receive(:destroy) { false }
      end

      it "destroying the requested exercice fails " do
        expect {
          delete url, params: { id: exercice.to_param }
        }.to change(Exercice, :count).by(0)
      end
      it "redirects to the exercice page" do
        delete url, params: { id: exercice.to_param }
        expect(response).to redirect_to exercice_path(exercice)
      end
    end
  end
end
