# frozen_string_literal: true

module Yams

  class Mp3PropertiesService

    include Yams::Services

    include ActiveStorage::Downloading

    attr_reader :blob

    def initialize(storage)
      @blob = storage
    end

    def self.length(storage)
      new(storage).length
    end

    def length
      download_blob_to_tempfile do |file|
        Rails.logger.debug("Mp3PropertiesService calculating Durations for #{file.path.inspect}")
        Yams::AudioService.get_duration_secs(file.path)
      end
    end

  end
end