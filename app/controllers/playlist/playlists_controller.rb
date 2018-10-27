# frozen_string_literal: true

class Playlist::PlaylistsController < ApplicationController

  before_action :authenticate_user!

  before_action :set_playlist, only: %i[show edit destroy]

  before_action :set_presenter, only: %i[edit update]

  helper DatashiftAudioEngine::ApplicationHelper

  layout 'application_with_player', only: %i[index show]

  def index
    @playlists = Playlist.for_user(current_user).page(params[:page]).per(30)
  end

  def show;
    # Render the Audio Player via HTML first
    # Player partial will then make a callback to get the JSON Playlist
    respond_to do |format|
      format.html {}
      format.json do
        @tracks_json = Yams::AudioEnginePlayListBuilder.call(@playlist.tracks, current_user)
      end
    end
  end

  def new
    @playlist = Playlist.new(user: current_user)
  end


  def edit; end

  def create

    @playlist = PlaylistPresenter.new(Playlist.new(playlist_params), view_context)

    @playlist.user = current_user if @playlist.user.blank?

    respond_to do |format|

      if @playlist.save
        format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
        format.json { render :show, status: :created, location: @playlist }
        format.js   { flash.now[:notice] = 'Playlist was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
        format.js   { flash.now[:error] = @playlist.errors.full_messages if @playlist.errors.any? }
      end

    end
  end

  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to edit_playlist_path(@playlist), notice: 'Playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: 'Playlist was successfully removed.' }
      format.json { head :no_content }
      format.js   { flash.now[:notice] = 'Playlist was successfully removed.' }
    end
  end

  private

  def set_presenter
    @playlist = PlaylistPresenter.new(Playlist.find(params[:id]), view_context)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_playlist
    @playlist = Playlist.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def playlist_params
    params.require(:playlist).permit(:name, :user_id, tag_list: [])
  end
end
