# frozen_string_literal: true

require 'thor'
require 'datashift'

DataShift.load_commands

module Yams
  class Db < Thor

    desc :seed_music, 'seed database with some music'
    def seed_music
      system 'thor datashift:import:excel -i db/seed/aqwan_tracks.xls -m Track -c db/seed/aqwan_tracks_import.yaml'
    end
  end
end
