require 'rails_helper'

RSpec.feature  "Users list" , :type => :feature do
  # feature "Users setup feature" do
  #   given!(:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
  #
  #   before :each do
  #     log_in admin
  #     visit new_user_path
  #     within "#new_user" do
  #       fill_in "user_firstname", with: "Edouard"
  #       fill_in "user_lastname", with: "Duchemin"
  #       fill_in "user_email", with: "truc@hoc.fr"
  #     end
  #     click_button(I18n.t("helpers.submit.user.create"))
  #   end
  #   it "should add a User" do
  #     expect(User.last.email).to eq("truc@hoc.fr")
  #     expect(User.last.status).to eq("setup")
  #   end
  #   it "refuses to add twice the same User" do
  #     visit new_user_path
  #     within "#new_user" do
  #       fill_in "user_firstname", with: "Edouard"
  #       fill_in "user_lastname", with: "Duchemin"
  #       fill_in "user_email", with: "truc@hoc.fr"
  #     end
  #     click_button(I18n.t("helpers.submit.user.create"))
  #     expect(page.body).to have_content(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
  #   end
  #   it "should send to the new user a welcome mail " do
  #     expect(last_email_address).to eq("truc@hoc.fr")
  #   end
  #   it "welcome mail should have the right subject " do
  #     binding.pry
  #     expect(last_email.subject).to eq("subject")
  #   end
  #   it "welcome mail should have the right body " do
  #     expect(last_email.body.encoded).to have_content("body body")
  #   end
  # end

  feature "Users promote Mail feature" do
    given!(:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given!(:player) { create(:user, :player, :registered) }

    before :each do
      log_in admin
      visit user_path(player)
      page.find('.users_promote').find("option[value='admin']").select_option
      click_button(I18n.t("users.promote"))
    end

    it "should send to the user a promote mail " do
      expect(last_email_address).to eq(player.email)
    end
    it "welcome mail should have the subject " do
      expect(last_email.subject).to eq(I18n.t("users.promote_mail.subject"))
    end
    it "welcome mail should have the right body " do
      status_text = "L'administrateur vient de changer ton statut sur le site"
      expect(last_email.body.encoded).to have_content(status_text)
    end
  end
end


# login_as create( :user ), scope: :user
#
# visit new_user_invitation_path
#
# within "#new_user" do
#   fill_in "user_email", with: "will@happyfuncorp.com"
# end
#
# click_button "Invite User"
#
# expect( page.body ).to include( "An invitation email has been sent" )
#
# body = ActionMailer::Base.deliveries.last.body
#
# md = body.encoded.match /(\/users\/invitation\/accept.*?)"/
# if !md
#   assert( false, "URL NOT FOUND IN MESSAGE")
# end
#
# logout
#
# visit md[1]
#
# expect( page.body ).to_not include( "You are already signed in." )
#
# within "#edit_user" do
#   fill_in "user_password", with: "1234567890"
#   fill_in "user_password_confirmation", with: "1234567890"
# end
#
# click_button "Add password"
#
# expect( page.body ).to include( "Your password was set successfully." )
