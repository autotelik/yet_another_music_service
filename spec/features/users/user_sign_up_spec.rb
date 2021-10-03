# frozen_string_literal: true

require 'rails_helper'

describe 'User', type: :feature do
  def fill_in_email(email = 'tester@example.tld')
    fill_in 'user_email', with: email
  end

  def submit
    click_button 'Create account'
  end

  context 'User register' do
    scenario 'with valid details' do
      visit root_path

      within('.navbar') do
        click_link I18n.t(:sign_up, scope: :global)
      end

      expect(current_path).to eq(yams_core.new_user_registration_path)

      fill_in_email
      fill_in 'user_password', with: 'test-password'
      fill_in 'user_password_confirmation', with: 'test-password'
      click_button 'Create account'

      expect(current_path).to eq '/'
      expect(page).to have_content(
        "A message with a confirmation link has been sent to your email address.
      Please follow the link to activate your account."
      )

      open_email 'tester@example.tld'
      current_email.click_link 'Confirm my account'

      expect(current_path).to eq yams_core.new_user_session_path
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      fill_in_email
      fill_in 'Password', with: 'test-password'
      click_button I18n.t(:sign_in, scope: :global)

      expect(current_path).to eq '/'
      expect(page).to have_content 'Signed in successfully.'
    end

    context 'with invalid details' do
      before do
        visit yams_core.new_user_registration_path
      end

      scenario 'blank fields' do
        expect_fields_to_be_blank

        submit

        expect(page).to have_text "Email can't be blank", "Password can't be blank"
      end

      scenario 'incorrect password confirmation' do
        fill_in_email
        fill_in 'user_password', with: 'test-password'
        fill_in 'user_password_confirmation', with: 'not-test-password'
        submit

        expect(page).to have_text "Password confirmation doesn't match Password"
      end

      scenario 'already registered email' do
        create(:user, email: 'tester@example.tld')

        fill_in_email
        fill_in 'user_password', with: 'test-password'
        fill_in 'user_password_confirmation', with: 'test-password'
        submit

        expect(page).to have_text 'Email has already been taken'
      end

      scenario 'invalid email' do
        fill_in_email 'invalid-email-for-testing'
        fill_in 'user_password', with: 'test-password'
        fill_in 'user_password_confirmation', with: 'test-password'
        submit

        expect(page).to have_text 'Email is invalid'
      end

      scenario 'too short password' do
        min_password_length = 8
        too_short_password = 'p' * (min_password_length - 1)
        fill_in 'user_email', with: 'someone@example.tld'
        fill_in 'user_password', with: too_short_password
        fill_in 'user_password_confirmation', with: too_short_password
        submit

        expect(page).to have_text 'Password is too short (minimum is 8 characters)'
      end
    end

    private

    def expect_fields_to_be_blank
      expect(page).to have_field('user_email', with: '', type: 'email')
      # These password fields don't have value attributes in the generated HTML,
      # so with: syntax doesn't work.
      expect(find_field('user_password', type: 'password').value).to be_nil
      expect(find_field('user_password_confirmation', type: 'password').value).to be_nil
    end
  end
end
