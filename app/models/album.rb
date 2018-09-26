# frozen_string_literal: true

class Album < ApplicationRecord

  acts_as_taggable

  searchkick callbacks: :queue

  belongs_to :user

  has_many :album_tracks, class_name: 'AlbumTrack'
  has_many :tracks, through: :album_tracks, class_name: 'Track'

  has_one :cover, as: :owner, dependent: :destroy
  accepts_nested_attributes_for :cover, allow_destroy: true

  enum published_state: %i[draft published]

  validates_presence_of :title

  validates :title, uniqueness: { scope: :user }

  scope :current, -> (user) { Album.where('user_id = ?', user.id) }

  scope :without_track, -> (track, user) { Album.current(user).where.not(id: AlbumTrack.where('track_id = ?', track.id).select(:album_id)) }

  after_save :after_save_hook

  def attach_cover(file_name)
    update(cover: Cover.create!(owner: self, image: File.open(file_name)))
  end

  private

  def after_save_hook

    begin
      Rails.logger.debug("Calling Searchkick to update ES Album Index")
      Searchkick::ProcessQueueJob.perform_later(class_name: "Album")

      # Not sure queue works yet - TODO delete this once jobs performant
      Album.reindex

    rescue Redis::CannotConnectError => x
      Rails.logger.error("Redis DOWN - Elastic search update failed #{x.message}")
    rescue  => x
      Rails.logger.error("UNHANDLED - Elastic search update failed #{x.message}")
    end

  end

end
