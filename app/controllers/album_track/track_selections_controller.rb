# frozen_string_literal: true

class AlbumTrack::TrackSelectionsController < ApplicationController

  before_action :set_album, only: %i[create]

  def create
    track = Track.find(album_track_params[:track_id])

    @album_track = AlbumTrack.new(album: @album, track: Track.find(album_track_params[:track_id]))

    @track = TrackPresenter.new(track, view_context)

    respond_to do |format|
      if @album_track.save
        format.js   { }
      else
        format.json { render json: @album_track.errors, status: :unprocessable_entity }
        format.js   { flash.now[:error] = @album_track.errors.full_messages }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_album
    @album = Album.find(album_track_params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def album_track_params
    params.require(:album_track).permit(:id, :track_id)
  end

end

