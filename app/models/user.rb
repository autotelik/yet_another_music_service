# frozen_string_literal: true

class User < ApplicationRecord

  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy

  enum role: %i[users vip admin]
  after_initialize :set_default_role, if: :new_record?

  has_one_attached :avatar#, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ':style/missing.png'
  # TODO validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  acts_as_taggable

  def set_default_role
    self.role ||= :users
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  # TODO: tokens - https://github.com/waiting-for-dev/devise-jwt
  # :jwt_authenticatable, jwt_revocation_strategy: Blacklist
end
