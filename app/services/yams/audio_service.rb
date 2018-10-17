# frozen_string_literal: true

module Yams

  class AudioService

    include Yams::Services

    def self.valid_types
      %w[audio/mpeg audio/x-wav audio/x-mpeg audio/mp3 audio/x-mp3 audio/mpeg3 audio/x-mpeg3 audio/mpg audio/x-mpg audio/x-mpegaudio application/octet-stream]
    end

    # Uses ffmpeg to calculate the duration in seconds of an mp3 on the filesystem
    #
    def self.get_duration_secs(filepath)
      pipe = "ffmpeg -i #{filepath} 2>&1 | grep 'Duration' | cut -d ' ' -f 4 | sed s/,//"
      command = `#{pipe}`
      duration = if command =~ /([\d][\d]):([\d][\d]):([\d][\d]).([\d]+)/
                   (Regexp.last_match(2).to_i * 60) + Regexp.last_match(3).to_i # convert the result to only secs
                 else
                   0
                 end

      duration
    end

  end
end
