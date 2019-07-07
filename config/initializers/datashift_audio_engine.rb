# Use this hook to configure datashift_audio_engine audio engine processing

DatashiftAudioEngine::Config.configure do |config|

  # routes
  #
  # Url of action to authorize user and will load personalized information about player right for current user
  #
  # config.init_url = "";

  # Url of action which will form playlist load action with params
  # config.load_url = "";

  # Url of action which will control save action
  # config.save_url = "";

  # Url of action which will control radio streaming action - Not USED Yet
  # config.radio_url = "";

  # Player can start playing audio on page load, rather than waiting for visitor to click play.
  #
  # Default is false
  config.autoplay = false

  config.random  = false
  config.repeat  = false
  config.volume  = 0.5     # - 0 .. 1

  # Player will report back current status to a save callback.
  # This parameter can be used to set the interval between reports in milliseconds.
  #
  # TODO - Support a list of intervals
  # We want a report at start, 30 seconds and 60 seconds and end
  config.save_interval = 30000; #  - in milliseconds

  # Waveform colors.
  #
  #config.wave_color = '#729f98'
  #config.progress_color = '#729f98'
  #config.cursor_color = '#729f98'
  #
  # width in pixels
  # config.bar_width;
  #


end
