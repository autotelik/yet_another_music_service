# frozen_string_literal: true

include Warden::Test::Helpers
Warden.test_mode!

feature 'User index page', :devise do
  after(:each) do
    Warden.test_reset!
  end

  # Feature: User index page
  #   As an Admin user
  #   I want to see a list of users
  #   So I can see who has registered
  scenario 'users sees own email address' do
    pending 'admin'
    user = FactoryBot.create(:user, :admin)
    login_as(user, scope: :users)
    visit users_path
    expect(page).to have_content user.email
  end
end
