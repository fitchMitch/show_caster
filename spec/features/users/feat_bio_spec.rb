require 'rails_helper'

RSpec.feature 'bio feature', type: :feature do
  given!(:admin) { create(:user, :admin, :registered, lastname: 'ADMIN') }
  let(:bio) { 'The Whole Story of my Life' }

  before :each do
    log_in admin
    visit user_path(admin)
    click_link(I18n.t('users.bio'))
    sleep 0.25
    within '.user_bio' do
      fill_in 'user_bio', with: bio
    end
    click_button(I18n.t('users.bio_submit'))
  end
  it 'should save and show a bio' do
    page_attr_matcher(User.last, %w[firstname lastname])
    expect(page.body).to have_content(I18n.t('users.bio_successfull'))
    click_link(I18n.t('users.bio'))
    sleep 0.25
    expect(page.body).to have_content(bio)
  end
end
