# frozen_string_literal: true

require_relative 'common/task_common'

module Yams
  class Db < Thor

    include TaskCommon

    desc :seed_music, 'For development - seed database with default albums/playlists and music specified in Excel'

    method_option :user, default: 'aqwan', desc: 'The artists to assign loaded tracks to'
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


      invoke 'datashift:import:excel', [], ['-i', excel, '-m', 'YamsCore::Track', '-c', track_upload_config]
    end

    desc :bulk_upload, 'seed database with music specified in Excel'

    method_option :excel, desc: 'Full Path to the loading Spreadsheet'


    def bulk_upload
      load_rails_environment

      require 'datashift'

      DataShift.load_commands

      invoke 'datashift:import:excel', [], ['-i', options[:excel], '-m', 'YamsCore::Track', '-c', track_upload_config]
    end

    no_commands do
      def track_upload_config
        @track_upload_config ||= File.join(::Rails.root, 'db/seed/config/tracks_import.yaml')
      end
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
