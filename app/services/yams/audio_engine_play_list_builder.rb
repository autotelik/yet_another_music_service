# frozen_string_literal: true

module Yams

  class AudioEnginePlayListBuilder

    include Rails.application.routes.url_helpers

    include Yams::Services

    def initialize(tracks, current_user)
      @tracks = *tracks
      @current_user = current_user
      @per_page = 30
    end

    def call
      @tracks.collect { |track| package(track) }
    end

    def package(track)
      {
        id: track.id,
        author: track.artist,
        name: track.title,
        audio_url: rails_blob_path(track.audio, only_path: true),
        cover_image: url_for(track.cover_image.variant(resize: '120x120')),
        duration: track.duration
      }
    end

    private

    attr_reader :current_user, :per_page, :tracks
  end
end
