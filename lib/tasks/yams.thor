# frozen_string_literal: true

require_relative 'common/task_common'
require 'datashift'

DataShift.load_commands

module Yams
  class Db < Thor

    include TaskCommon

    desc :seed_music, 'seed database with some music, albums and playlists - useful in dev'

    method_option :user, default: 'aqwan'

    def seed_music

      load_rails_environment

      user = User.where(name: options[:user]).first

      Album.create(user: user, title: 'Photon Histories', description: 'Demo album loaded via db:seed', published_state: "published")
      Album.create(user: user, title: 'Serrated Ambient Twerks', description: 'Ambient glitch', published_state: "published")

      Playlist.create(user: user, name: 'All time faves')
      Playlist.create(user: user, name: 'The Best')
      Playlist.create(user: user, name: 'Top of the Pops')
      Playlist.create(user: user, name: 'Chillout')

      system 'thor datashift:import:excel -i db/seed/aqwan_tracks.xls -m Track -c db/seed/aqwan_tracks_import.yaml'
    end
  end
end
