# frozen_string_literal: true

class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.admin?
  end

  # Logged in users can see other artists profiles
  def show?
    @current_user.admin? || @current_user
  end

  def update?
    @current_user.admin? || @current_user == @user
  end

  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end

end
