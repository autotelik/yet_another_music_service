# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout 'welcome', only: %i[new create]
end
