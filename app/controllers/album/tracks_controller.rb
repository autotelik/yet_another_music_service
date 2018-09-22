# frozen_string_literal: true

class Album::TracksController < ApplicationController

  before_action :set_album

  def destroy
    @album.tracks.destroy_all

    respond_to do |format|
      format.html { redirect_to @album }
      format.js
    end
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

end
