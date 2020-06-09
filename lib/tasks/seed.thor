# frozen_string_literal: true

require_relative 'common/task_common'

module Yams
  class Db < Thor

    include TaskCommon

    desc :seed_music, 'seed database with some music, albums and playlists - useful in dev'

    method_option :user, default: 'aqwan'
    method_option :excel, desc: 'Full Path to the loading Spreadsheet'

    def seed_music
      load_rails_environment

      excel = options[:excel] || File.join(::Rails.root, 'db/seed/aqwan_tracks.xls')

      require 'datashift'

      DataShift.load_commands

      user = ::YamsCore::User.where(name: options[:user]).first

      ::YamsCore::Album.create(user: user, title: 'Photon Histories',
                               description: 'Demo album loaded via db:seed',
                               published_state: 'published')
      ::YamsCore::Album.create(user: user, title: 'Serrated Ambient Twerks',
                               description: 'Ambient glitch',
                               published_state: 'published')

      ::YamsCore::Playlist.create(user: user, name: 'All time faves')
      ::YamsCore::Playlist.create(user: user, name: 'The Best')
      ::YamsCore::Playlist.create(user: user, name: 'Top of the Pops')
      ::YamsCore::Playlist.create(user: user, name: 'Chillout')

      # excel = File.join(::Rails.root, 'db/seed/aqwan_tracks.xls')
      # excel = File.join(::Rails.root, 'db/seed/aqwan_33_tracks.xls')
      config = File.join(::Rails.root, 'db/seed/aqwan_tracks_import.yaml')

      invoke 'datashift:import:excel', [], ['-i', excel, '-m', 'YamsCore::Track', '-c', config]
    end
  end

  class SearchIndex < Thor

    include TaskCommon
    desc :build, 'Build full Index for Elastic Search'

    def build
      load_rails_environment

      ::YamsCore::Track.reindex
      ::YamsCore::Album.reindex
    end
  end

end
