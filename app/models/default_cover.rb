# frozen_string_literal: true

class DefaultCover < ApplicationRecord

  include Yams::Covering

  enum kind: %i[album artist track user]

  def self.for_album
    where(kind: :album).first
  end

  def self.for_artist
    where(kind: :artist).first
  end

  def self.for_track
    where(kind: :track).first
  end

  def self.for_user
    where(kind: :user).first
  end
end
