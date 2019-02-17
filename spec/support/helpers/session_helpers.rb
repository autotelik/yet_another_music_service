# frozen_string_literal: true

module Features
  module SessionHelpers
    def sign_up_with(email, password, confirmation)
      visit yams_core.new_user_registration_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: confirmation
      click_button I18n.t('devise.registrations.new.submit')
     end

    def signin(email, password)
      visit yams_core.new_user_session_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      click_button I18n.t('devise.sessions.new.submit')
    end
  end
end
