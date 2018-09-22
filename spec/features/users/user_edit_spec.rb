# frozen_string_literal: true

require 'rails_helper'

Warden.test_mode!

# Feature: User edit
#   As a users
#   I want to edit my users profile
#   So I can change my email address
feature 'User edit', :devise do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: User changes email address
  #   Given I am signed in
  #   When I change my email address
  #   Then I see an account updated message
  scenario 'users changes email address' do
    visit edit_user_registration_path(user)
    fill_in 'user_email', with: 'newemail@example.com'
    fill_in 'user_name', with: 'aqwan'
    click_button I18n.t('devise.registrations.form.submit')
    txts = [I18n.t('devise.registrations.updated'), I18n.t('devise.registrations.update_needs_confirmation')]
    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end

  # Scenario: User cannot edit another users's profile
  #   Given I am signed in
  #   When I try to edit another users's profile
  #   Then I see my own 'edit profile' page
  scenario "users cannot cannot edit another users's profile", :me do
    other = FactoryBot.create(:user, email: 'other@example.com')
    visit edit_user_registration_path(other)
    # save_and_open_page

    expect(page).to have_content I18n.t('devise.registrations.form.panel_title')
    expect(page).to have_field('user_email', with: user.email)
  end
end
