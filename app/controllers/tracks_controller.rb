# frozen_string_literal: true

class TracksController < ApplicationController

  before_action :set_track,     only: %i[destroy]
  before_action :set_presenter, only: %i[edit update show]

  helper DatashiftAudioEngine::ApplicationHelper

  layout 'application_with_player', only: [:show]

  # GET /tracks
  # GET /tracks.json
  def index
    # Technique to generate same list for a certain time - driven by the cookie expire time
    # seed_val = Track.connection.quote(cookies[:rand_seed])
    seed_val = rand
    Track.connection.execute("select setseed(#{seed_val})")
    @tracks = Track.eager_load(:cover, :user).for_commercial.order('random()').page(params[:page]).per(30)

    @radio_tracks_json = Yams::AudioEnginePlayListBuilder.call(@tracks, current_user)

    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show;
    respond_to do |format|
      format.html {}
      format.json { @track_json = Yams::AudioEnginePlayListBuilder.call(@track, current_user) }
    end
  end

  # GET /tracks/new
  def new
    @track = Track.new.tap do |track|
      track.availables.build
      track.build_cover
    end
  end

  # GET /tracks/1/edit
  def edit
    @track.availables.build if @track.availables.blank?
  end

  # TODO: forms are AJAX by default we should implement error handling etc and then we can remove from form 'local: true'
  def create
    @track = Track.new(track_params).tap do |t|
      t.user = current_user
    end

    respond_to do |format|
      if @track.save

        available_for_params[:availables].keys.each { |mode| @track.make_available_for(mode) } if available_for_params[:availables].present?

        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render :show, status: :created, location: @track }
      else
        format.html do
          @cover = @track.build_cover
          render :new, notice: 'Track upload failed.'
        end
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracks/1
  # PATCH/PUT /tracks/1.json
  def update
    respond_to do |format|
      if update_track
        format.html { redirect_to edit_track_path(@track), notice: 'Track was successfully updated.' }
        format.json { render :show, status: :ok, location: @track }
      else
        format.html { render :edit }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track.destroy
    respond_to do |format|
      format.html { redirect_to tracks_url, notice: 'Track was successfully removed.' }
      format.json { head :no_content }
      format.js   { render :destroy, notice: 'Track was successfully removed.' }
    end
  end

  private

  def update_track
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless @track.update(track_params)
      # params contains only those selected, so first destroy the existing set
      @track.availables.delete_all
      available_for_params[:availables].keys.each { |mode| @track.make_available_for(mode) } if available_for_params[:availables].present?
      return true
    end

    false
  end

  def set_presenter
    @track = TrackPresenter.new(Track.find(params[:id]), view_context)
  end

  def set_track
    @track = Track.find(params[:id])
  end

  def track_params
    params.require(:track).permit(:audio, :description, :license_id, :release_year, :release_month, :release_day, :title, :user_id, tag_list: [], cover_attributes: %i[id image])
  end

  def available_for_params
    params.permit(availables: Available.concepts.keys)
  end

end
