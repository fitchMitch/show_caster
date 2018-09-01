require 'rails_helper'

RSpec.feature  "new users features", type: :feature do
  given!(:admin) { create(:user, :admin, :registered, lastname: "ADMIN") }

  before :each do
    log_in admin
    visit new_user_path
    within "#new_user" do
      fill_in "user_firstname", with: "Edouard"
      fill_in "user_lastname", with: "Duchemin"
      fill_in "user_email", with: "truc@hoc.fr"
    end
    click_button(I18n.t("helpers.submit.user.create"))
  end
  it "should add a User" do
    expect(User.last.email).to eq("truc@hoc.fr")
    expect(User.last.status).to eq("setup")
  end
  it "refuses to add twice the same User" do
    visit new_user_path
    within "#new_user" do
      fill_in "user_firstname", with: "Edouard"
      fill_in "user_lastname", with: "Duchemin"
      fill_in "user_email", with: "truc@hoc.fr"
    end
    click_button(I18n.t("helpers.submit.user.create"))
    expect(page.body).to have_content(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
  end
end
