# frozen_string_literal: true

class Playlist::ManagementController < ApplicationController

  def index
    @playlists = Playlist.for_user(current_user)

    @tracks = Track.for_user(current_user).page(params[:page]).per(30)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def playlist_params
    params.require(:playlist).permit(:title, :description, :published_state, :user_id, tag_list: [], cover_attributes: %i[id image])
  end
end
