# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout 'welcome', only: %i[new create]

  include PunditHelper

  def show
    @user = User.find(params[:id])
    authorize @user
    render :show
  end
  # PUT /resource
  # for now we wont require current password on any change including password change
  # Devise default is to require a password checks on any update.

  def update_resource(resource, params)
    # if params['email'] != current_user.email || params['password'].present?
    #  resource.update_with_password(params)
    # else
    authorize resource
    resource.update_without_password(params.except('password', 'password_confirmation', 'current_password'))
    # end
  end

  def sign_up_params
    params.require(:user).permit(:avatar, :name, :email, :password, :password_confirmation, :tag_list)
  end

  def account_update_params
    params.require(:user).permit(:avatar, :current_password, :name, :email, :password, :password_confirmation, :tag_list)
  end

end
