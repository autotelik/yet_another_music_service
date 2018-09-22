# frozen_string_literal: true

# Feature: Sign in
#   As a users
#   I want to sign in
#   So I can visit protected areas of the site
feature 'Sign in', :devise do
  let(:authentication_key) { 'Email' }

  # Scenario: User cannot sign in if not registered
  #   Given I do not exist as a users
  #   When I sign in with valid credentials
  #   Then I see an invalid credentials message
  #

  scenario 'users cannot sign in if not registered' do
    signin('test@example.com', 'please123')
    expect(page).to have_text I18n.t('devise.failure.not_found_in_database', authentication_keys: authentication_key)
  end

  let(:user) { FactoryBot.create(:user) }

  # Scenario: User can sign in with valid credentials
  #   Given I exist as a users
  #   And I am not signed in
  #   When I sign in with valid credentials
  #   Then I see a success message
  scenario 'users can sign in with valid credentials' do
    signin(user.email, user.password)
    expect(page).to have_text I18n.t('devise.sessions.signed_in', authentication_keys: authentication_key)
  end

  # Scenario: User cannot sign in with wrong email
  #   Given I exist as a users
  #   And I am not signed in
  #   When I sign in with a wrong email
  #   Then I see an invalid email message
  scenario 'users cannot sign in with wrong email' do
    signin('invalid@email.com', user.password)
    expect(page).to have_text I18n.t('devise.failure.not_found_in_database', authentication_keys: authentication_key)
  end

  # Scenario: User cannot sign in with wrong password
  #   Given I exist as a users
  #   And I am not signed in
  #   When I sign in with a wrong password
  #   Then I see an invalid password message
  scenario 'users cannot sign in with wrong password' do
    signin(user.email, 'invalidpass')
    expect(page).to have_content I18n.t('devise.failure.invalid', authentication_keys: authentication_key)
  end
end
