# Use this hook to configure yams_audio_engine processing

YamsAudio::Config.configure do |config|

  # Waveform colors.
  #
  config.wave_color     = '#4d4d4e'
  config.progress_color = '#f7931a'
  config.cursor_color   = '#010101'

  # Player can start playing audio on page load, rather than waiting for visitor to click play.
  #
  config.autoplay = false
  config.random  = false
  config.repeat  = false

  # Player will report back current status to a save callback.
  # This parameter can be used to set the interval between reports in milliseconds.
  #
  # TODO - Support a list of intervals
  # We want a report at start, 30 seconds and 60 seconds and end
  config.save_interval = 30000; #  - in milliseconds

end

