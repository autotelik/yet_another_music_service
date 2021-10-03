# frozen_string_literal: true

module Features
  module SessionHelpers

    def sign_up_with(email, password, confirmation)
      visit pulse_pro_core.new_user_registration_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: confirmation
      click_button I18n.t(:sign_up, scope: :global)
    end

    def grantee_signin(email, password)
      visit '/grantees/sign_in'
      fill_in 'email', with: email
      fill_in 'password', with: password
      click_button I18n.t(:sign_in, scope: :global)
    end

  end
end


