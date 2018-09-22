# frozen_string_literal: true

module Yams

  class AudioService

    include Yams::Services

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
