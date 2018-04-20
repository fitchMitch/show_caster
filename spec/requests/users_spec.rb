require 'rails_helper'
# require 'vcr'

 RSpec.describe "Users", type: :request do
   let (:valid_attributes) {
         {firstname: "eric",
         lastname: "bicon",
         email: "gogo@lele.fr",
         cell_phone_nr: "0123456789"}
       }
   let (:new_valid_attributes) {
         {firstname: "Gelle",
         lastname: "Lieffer",
         email: "gaga@lele.fr",
         cell_phone_nr: "0123488789"}
       }
   let (:invalid_attributes) {
         {firstname: "eric",
         lastname: "bicon",
         email: "gogo@lelefr",
         cell_phone_nr: "0123456789"}
       }
  context "/ As logged as admin," do
    before :each do
      # admin = create(:user_admin, uid: "105205260860062499768", email:"etienne.weil@gmail.com")
      # request_log_in(admin)
    end

    describe "GET #index" do
      it "renders users index" do
        get '/users/new'
        expect(response).to render_template(:new)
      end
    end
    describe "NEW" do
      it "builds a new User" do
        user = User.new valid_attributes
        expect(user).to be_valid
        post '/users', params: {user: valid_attributes}
        expect(response).to redirect_to users_path
      end
    end
    describe "POST #create" do
      context "with valid params" do
        it "creates a new User" do
          user = User.new valid_attributes
          expect(user).to be_valid
          post '/users', params: {user: valid_attributes}
          expect(response).to redirect_to users_path
        end
      end
      context "with invalid params" do
        it "fails to create a new User" do
          user = User.new invalid_attributes
          expect(user).not_to be_valid
          post '/users', params: {user: invalid_attributes}
          expect(response).to render_template(:new)
        end
      end
    end
    describe "UPDATE #update" do
      context "with valid params" do
        before :each do
          @user = create(:user, :admin, :set_up)
          @url = "/users/#{@user.id}"
        end
        it "builds a new User" do
          put @url, params: {id: @user.id, user: new_valid_attributes}
          expect(response).to redirect_to users_path
        end
      end
      context "with invalid params" do
        before :each do
          @user = create(:user, :admin, :set_up)
          @url = "/users/#{@user.id}"
        end
        it "fails to update user" do
          put @url, params: {id: @user.id, user: invalid_attributes}
          expect(response).to render_template(:edit)
        end
      end
    end

        # it "creates a new User", :vcr do
        #   expect {
        #     post '/users', params: {user: valid_attributes}
        #   }.to change(User, :count).by(1)
        # end

        # it "assigns a newly created user as @user and formats cell_phone_nr" do
        #   post '/users', params: {user: valid_attributes}
        #   expect(User.last.user_name).to eq("A la belle Etoile")
        # end
        #
        # it "redirects to the created user" do
        #   post '/users', params: {user: valid_attributes}
        #   l = User.find_by(user_name: valid_attributes[:user_name])
        #   expect(response).to redirect_to user_path(l)
        # end

      # context "with invalid params" do
      #   it "re-renders the 'new' template" do
      #     post '/users', params: {user: invalid_attributes_address_only}
      #     expect(response).to render_template :new
      #   end
      #
      #   it "doesn't persist user" do
      #     expect {
      #       post '/users', params: {user: invalid_attributes_address_only}
      #     }.to change(User, :count).by(0)
      #   end
      # end
    end

 end


  # describe "PUT #update" do
  #
  #   context "with valid params" do
  #     before :each do
  #       admin = create(:user_admin)
  #       request_log_in(admin)
  #     end
  #     let(:new_attributes_user_name) {
  #       {user_name: "Sous les ponts"}
  #     }
  #     let(:new_attributes) {
  #       { user_address: 'xx, rue de Lichtenstein PARIS 12',
  #         tenant: "Tenardier",
  #         tenant_phone: "0666666666"
  #       }
  #     }
  #     let(:valid_session) { request_log_in(create(:user_admin, lastname: "ADMIN")) }
  #     let(:user) { create(:user) }
  #
  #     it "updates the requested user_name with a new user_name" do
  #       url = "/users/#{user.to_param}"
  #       put url , params:{ id: user.id, user: new_attributes_user_name }
  #       user.reload
  #       expect(user).to have_attributes(
  #         user_name: new_attributes_user_name[:user_name]
  #       )
  #     end
  #
  #     it "updates the requested user" do
  #       url = "/users/#{user.to_param}"
  #       put url , params:{ id: user.id, user: new_attributes}
  #       user.reload
  #       expect(user).to have_attributes( tenant_phone: '06 66 66 66 66' )
  #       expect(user).to have_attributes( tenant: new_attributes[:tenant])
  #       expect(user).to have_attributes( user_address: new_attributes[:user_address] )
  #     end
  #
  #     it "redirects to the users page" do
  #       url = "/users/#{user.to_param}"
  #       put url , params:{ id: user.id, user: new_attributes }
  #       expect(response).to redirect_to user_path(user.id)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     before :each do
  #       admin = create(:user_admin)
  #       request_log_in(admin)
  #     end
  #     let(:user) { create(:user) }
  #
  #     it "assigns the user as @user" do
  #       url = "/users/#{user.to_param}"
  #       put url , params:{ id: user.id, user: invalid_attributes }
  #       user.reload
  #       expect(user.user_name).not_to eq(invalid_attributes[:user_name])
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       url = "/users/#{user.to_param}"
  #       put url , params:{ id: user.id, user: invalid_attributes }
  #       expect(response).to render_template :edit
  #     end
  #   end
  # end
