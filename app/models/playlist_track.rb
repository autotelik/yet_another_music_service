# frozen_string_literal: true

class PlaylistTrack < ApplicationRecord

  include RailsSortable::Model
  set_sortable :sort

  # If you do NOT want timestamps to be updated on sorting, use the following option.
  set_sortable :sort, without_updating_timestamps: true

  belongs_to :playlist
  belongs_to :track

  validates :playlist, :track, presence: true
  validates :track, uniqueness: { scope: :playlist, message: ' is already present in that Playlist' }
end
