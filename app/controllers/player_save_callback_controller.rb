# frozen_string_literal: true

class PlayerSaveCallbackController < ApplicationController

  def create
    logger.debug("Callback reached [#{params}") if params['position'].to_i > 30 && params['position'].to_i < 32
    head :ok
  end

end
