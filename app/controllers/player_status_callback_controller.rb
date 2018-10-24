# frozen_string_literal: true

class PlayerStatusCallbackController < ApplicationController

  def create
    position= params['position'].to_i

    logger.debug("Callback reached [#{params}")
    logger.debug("30 second warning") if position >= 30
    logger.debug("60 second warning") if position >= 58 && position < 62
    logger.debug("Trigger Payment event if Track commercial") if position > 62
    head :ok
  end

end
