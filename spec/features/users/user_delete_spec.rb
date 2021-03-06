# frozen_string_literal: true

# Feature: User delete
#   As a users
#   I want to delete my users profile
#   So I can close my account
feature 'User delete', :devise, :js do

  include Warden::Test::Helpers
  Warden.test_mode!

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: User can delete own account
  #   Given I am signed in
  #   When I delete my account
  #   Then I should see an account deleted message
  scenario 'users can delete own account' do
    skip 'skip a slow test'
    user = FactoryBot.create(:user)
    login_as(user, scope: :users)
    visit edit_user_registration_path(user)
    click_button 'Cancel my account'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content I18n.t 'devise.registrations.destroyed'
  end
end
