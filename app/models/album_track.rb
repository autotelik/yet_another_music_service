# frozen_string_literal: true

class AlbumTrack < ApplicationRecord

  include RailsSortable::Model
  set_sortable :sort

  # If you do NOT want timestamps to be updated on sorting, use the following option.
  set_sortable :sort, without_updating_timestamps: true

  belongs_to :album
  belongs_to :track

  validates :album, :track, presence: true
  validates :track, uniqueness: { scope: :album, message: ' is already present in that Album' }
end
