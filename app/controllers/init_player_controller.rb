# frozen_string_literal: true

class InitPlayerController < ApplicationController

  helper DatashiftAudioEngine::ApplicationHelper

  def create

    # init -  it sends request during datashift_audio_engine.init() function call once
    # when we need to sync basic player settings possible
    # it sends local variables of {user_token} and {client_token}
    #
    respond_to do |format|
      format.json do
        data = { "client_token": "0987654321" }

        render json: data, status: 200
      end
    end
  end

end
