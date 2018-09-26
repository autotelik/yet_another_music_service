# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :user
  belongs_to :license, required: false # TODO
  belongs_to :id3_genre, required: false # TODO

  has_one :cover, as: :owner, dependent: :destroy
  accepts_nested_attributes_for :cover, allow_destroy: true

  has_many :album_tracks, class_name: 'AlbumTrack', dependent: :destroy
  has_many :albums, through: :album_tracks, class_name: 'Album'

  include Yams::AvailableFor

  acts_as_taggable

  searchkick callbacks: :queue

=begin
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  settings do
    mappings dynamic: false do
      indexes :title, type: :text, analyzer: :english # cases like singular/plural version of terms are treated the same way (and much more).
      indexes :tag_list, type: :text, analyzer: :english
    end
  end
=end

  after_create :after_create_hook

  after_save :after_save_hook

  def self.valid_types
    %w[audio/mpeg audio/x-wav audio/x-mpeg audio/mp3 audio/x-mp3 audio/mpeg3 audio/x-mpeg3 audio/mpg audio/x-mpg audio/x-mpegaudio application/octet-stream]
  end

  has_one_attached :audio
  # TODO  validates_attachment_content_type :audio, content_type: valid_types

  # TODO: - User
  validates_presence_of :title, :audio

  scope :no_album, -> { includes(:albums).where(albums: { id: nil }) }
  # scope :with_album, includes(:album_tracks).where.not(photos: { id: nil })

  scope :current, -> (user) { Track.where('user_id = ?', user.id) }

  scope :without_album, -> (album, user) { Track.current(user).where.not(id: AlbumTrack.where('album_id = ?', album.id).select(:track_id)) }

  def attach_audio_file(path)
    audio.attach(io: File.open(path), filename:  File.split(path).last, content_type: Track.valid_types)
  end

  def attach_cover(path)
    self.cover = Cover.create!(owner: self).tap{ |c| c.image.attach(io: File.open(path), filename: File.split(path).last) }
  end

  def cover_image(size: :thumb)
    track_cover = self.cover.try(:attached?) ? cover : DefaultCover.for_track
    track_cover.image
  end

  def artist
    user.try(:name)
  end

  def duration
    assign_mp3_properties unless length?
    length
  end

  def display_duration
    Time.at(duration).utc.strftime('%H:%M:%S')
  end

  private

  def assign_mp3_properties

    begin
      Rails.logger.debug("Calling Mp3Worker for Track #{id}")
      Mp3Worker.perform_async(id)
    rescue Redis::CannotConnectError => x
      Rails.logger.error("Redis DOWN - MP3 properties not updated #{x.message}")

    rescue  => x
      Rails.logger.error("UNHANDLED - MP3 properties not updated #{x.message}")
    end

  end

  def after_create_hook
    assign_mp3_properties
  end

  def after_save_hook

    begin
      Rails.logger.debug("Calling Searchkick to update ES Track Index")
      Searchkick::ProcessQueueJob.perform_later(class_name: "Track")

      # Not sure queue works yet - TODO delete this once jobs performant
      Track.reindex

    rescue Redis::CannotConnectError => x
      Rails.logger.error("Redis DOWN - Elastic search update failed #{x.message}")
    rescue  => x
      Rails.logger.error("UNHANDLED - Elastic search update failed #{x.message}")
    end

  end


end
