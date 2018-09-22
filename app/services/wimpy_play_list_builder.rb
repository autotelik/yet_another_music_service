# frozen_string_literal: true

class WimpyPlayListBuilder

  include Yams::Services

  def initialize(model)
    @model = model
  end

  # format required : data-media="song1.mp3|song2.mp3|song3.mp3"
  #
  def call
    case model
      when Track
        model.audio.url(model.audio.default_style, timestamp: false)
      when Album
        model.tracks.collect { |t| t.audio.url(t.audio.default_style, timestamp: false) }.join('|')
      else
        ''
    end
  end

  private

  attr_reader :model
end
