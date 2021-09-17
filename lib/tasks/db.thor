# frozen_string_literal: true

require_relative "common/task_common"

module Yams
  class Db < Thor
    include TaskCommon

    desc :seed_music, "For development - seed DB with music from file system specified in Excel"

    method_option :user, default: "aqwan", desc: "The artists to assign loaded tracks to"
    method_option :excel, desc: "Full Path to the loading Spreadsheet"

    def seed_music
      load_rails_environment

      excel = options[:excel] || File.join(::Rails.root, "db/seed/aqwan_tracks.xls")

      require "datashift"

      DataShift.load_commands

      invoke "datashift:import:excel", [], ["-i", excel, "-m", "YamsCore::Track", "-c", track_upload_config]
    end

    desc :seed_test_data, "For development - seed database with some dummy Albums and Playlists"

    method_option :user, aliases: "-u", default: "aqwan", desc: "The artists to use"
    method_option :clear, aliases: "-c", type: :boolean, default: false, desc: "Remove existing Albums and Playlists first"

    def seed_test_data
      load_rails_environment

      if options[:clear] && Rails.env.development?
        ::YamsCore::Playlist.destroy_all
        ::YamsCore::Album.destroy_all
      end

      user = ::YamsCore::User.find(options[:user])
      user ||= ::YamsCore::User.where(name: options[:user]).first

      (0..5).each do |name|
        ::YamsCore::Playlist.create!(user: user, name: Faker::Music.unique.album).tap do |pl|
          pl.tracks << ::YamsCore::Track.order("RANDOM()").limit(rand(1..15))
        end
      end

      (0..5).each do |i|
        ::YamsCore::Album.create!(user: user, title: Faker::Music.unique.album,
                                  description: "Demo #{Faker::Music.genre} loaded via db:seed",
                                  published_state: "published").tap do |a|
          a.tracks << ::YamsCore::Track.order("RANDOM()").limit(rand(1..15))
        end
      end
    end

    desc :bulk_upload, "seed database with music specified in Excel"

    method_option :excel, desc: "Full Path to the loading Spreadsheet"

    def bulk_upload
      load_rails_environment

      require "datashift"

      DataShift.load_commands

      invoke "datashift:import:excel", [], ["-i", options[:excel], "-m", "YamsCore::Track", "-c", track_upload_config]
    end

    no_commands do
      def track_upload_config
        @track_upload_config ||= File.join(::Rails.root, "db/seed/config/tracks_import.yaml")
      end
    end
  end

  class SearchIndex < Thor
    include TaskCommon
    desc :build, "Build full Index for Elastic Search"

    def build
      load_rails_environment

      ::YamsCore::Track.reindex
      ::YamsCore::Album.reindex
    end
  end
end
