# frozen_string_literal: true

class RadioController < ApplicationController

  after_action { puts response.body }

  def index
    per_page = 1

    # Technique to generate same list for a certain time - driven by the cookie expire time
    # seed_val = Track.connection.quote(cookies[:rand_seed])
    seed_val = rand
    Track.connection.execute("select setseed(#{seed_val})")

    @tracks = Track.eager_load(:cover, :user).for_radio.order('random()').page(params[:page]).per(30)

    @radio_tracks_json = Yams::AudioEnginePlayListBuilder.call(@tracks, current_user)

    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

end
