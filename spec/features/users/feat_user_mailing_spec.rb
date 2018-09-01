require 'rails_helper'

RSpec.feature  "Users", type: :feature do
  feature "invite mail feature" do
    given!(:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given!(:player) { create(:user, :player, :setup) }

    before :each do
      log_in admin
      visit users_path
      selector = ".row.user-list.#{player.firstname}.#{player.lastname}"
      within (selector) do
        find_button.click
      end
    end

    it "should send to the user a promote mail " do
      expect(last_email_address).to eq(player.email)
    end
    it "welcome mail should have the subject " do
      expect(last_email.subject).to eq(I18n.t("users.welcome_mail.subject"))
    end
    it "welcome mail should have the right body " do
      status_text = "accueillent avec plaisir"
      expect(last_email.body.encoded).to have_content(status_text)
    end
  end

  feature "invite mail feature is impossible" do
    given!(:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given!(:player) { create(:user, :player, :setup) }

    before :each do
      log_in admin
      visit users_path
      selector = ".row.user-list.#{player.firstname}.#{player.lastname}"
      within (selector) do
        find_button.click
      end
    end
    it "should send to the user a promote mail " do
      expect(page.body).not_to have_content(I18n.t("users.promote"))
    end
  end

  feature "promote mail feature" do
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

  feature "promote mail feature is impossible" do
    given!(:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }
    given!(:player) { create(:user, :player, :setup) }

    before :each do
      log_in admin
      visit user_path(player)
    end
    it "should send to the user a promote mail " do
      expect(page.body).not_to have_content(I18n.t("users.promote"))
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
