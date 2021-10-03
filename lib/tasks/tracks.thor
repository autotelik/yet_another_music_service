# frozen_string_literal: true

require_relative 'common/task_common'

module Yams

  class Tracks < Thor

    include TaskCommon

    desc :rebuild_mp3_properties, 'Extract meta data for Tracks from MP3 properties'

    method_option :id, aliases: '-i', desc: 'Track ID - Defaults to all Tracks'

    def rebuild_mp3_properties
      load_rails_environment

      if options[:id]
        ::YamsCore::Mp3Worker.perform_async(options[:id])
      else
        ::YamsCore::Track.all.each { |t| YamsCore::Mp3Worker.perform_async(t.id) }
      end

    end

    desc :play_lists, 'Create some dummy Playlists and assign random Tracks to them'

    method_option :id, aliases: '-i', desc: 'Track ID - Defaults to all Tracks'

    def play_lists
      load_rails_environment

      ::YamsCore::Playlist.create!

    end
  end
end
