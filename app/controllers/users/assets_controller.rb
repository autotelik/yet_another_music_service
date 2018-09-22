# frozen_string_literal: true

class Users::AssetsController < Devise::RegistrationsController
  layout 'welcome', only: %i[edit]
end
