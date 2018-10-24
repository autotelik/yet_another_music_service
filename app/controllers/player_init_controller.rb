# frozen_string_literal: true

class PlayerInitController < ApplicationController

  helper DatashiftAudioEngine::ApplicationHelper

  def create
    # The audio player init call back -  it sends request during datashift_audio_engine.init() function call once
    # when we need to sync basic player settings possible
    # We sends back variables like {user_token} and {client_token}
    #
  end

end
