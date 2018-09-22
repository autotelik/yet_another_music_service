# frozen_string_literal: true

class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # For returning random lists of records
  before_action :set_rand_cookie

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_rand_cookie
    return if cookies[:rand_seed].present?

    # Time will determine how quickly the randomisation resets
    cookies[:rand_seed] = { value: rand, expires: 1.second.from_now }
  end

end
