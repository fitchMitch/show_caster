require 'rails_helper'
# require 'vcr'

 RSpec.describe "Users", type: :request do
   let (:valid_attributes) {
         {firstname: "eric",
         lastname: "bicon",
         email: "gogo@lele.fr",
         cell_phone_nr: "0163456789"}
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
  context "As logged as admin," do

    describe "GET #index" do
      before :each do
        request_log_in_admin
      end
      it "renders users index" do
        get '/users/new'
        expect(response).to render_template(:new)
      end
    end
    describe "NEW" do
      before :each do
        request_log_in_admin
      end
      it "builds a new User" do
        user = User.new valid_attributes
        expect(user).to be_valid
        post '/users', params: {user: valid_attributes}
        expect(response).to redirect_to users_path
      end
    end
    describe "EDIT" do
      it "builds edits User" do
      admin = create(:user, :admin, :fully_registered)
      request_log_in(admin)
        get edit_user_path(admin)
        expect(response).to render_template :complement
      end
    end
    describe "POST #create" do
      context "with valid params" do
        before :each do
          request_log_in_admin
        end
        it "creates a new User" do
          user = User.new valid_attributes
          expect(user).to be_valid
          post '/users', params: {user: valid_attributes}
          expect(response).to redirect_to users_path
        end
      end
      context "with invalid params" do
        before :each do
          request_log_in_admin
        end
        it "fails to create a new User" do
          user = User.new invalid_attributes
          expect(user).not_to be_valid
          post '/users', params: {user: invalid_attributes}
          expect(response).to render_template(:new)
        end
      end
    end
    describe "UPDATE" do
      context "with valid params" do
        before :each do
          @admin = create(:user, :admin, :set_up)
          request_log_in @admin
          @url = "/users/#{@admin.id}"
        end
        it "is ok" do
          put @url, params: {id: @admin.id, user: new_valid_attributes}
          expect(response).to redirect_to users_path
        end
      end
      context "with invalid params" do
        before :each do
          @admin = create(:user, :admin, :set_up)
          request_log_in @admin
          @url = "/users/#{@admin.id}"
        end
        it "fails to update user" do
          put @url, params: {id: @admin.id, user: invalid_attributes}
          expect(response).to render_template(:edit)
        end
      end
    end
  end
  context "As visitor" do
    context "get INDEX" do
      it "renders users index" do
        get '/users/index'
        expect(response).to redirect_to root_path
      end
    end
  end
 end
