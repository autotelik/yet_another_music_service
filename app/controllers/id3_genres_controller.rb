# frozen_string_literal: true

class Id3GenresController < ApplicationController
  before_action :set_id3_genre, only: %i[show edit update destroy]

  # GET /id3_genres
  # GET /id3_genres.json
  def index
    @id3_genres = Id3Genre.all
  end

  # GET /id3_genres/1
  # GET /id3_genres/1.json
  def show; end

  # GET /id3_genres/new
  def new
    @id3_genre = Id3Genre.new
  end

  # GET /id3_genres/1/edit
  def edit; end

  # POST /id3_genres
  # POST /id3_genres.json
  def create
    @id3_genre = Id3Genre.new(id3_genre_params)

    respond_to do |format|
      if @id3_genre.save
        format.html { redirect_to @id3_genre, notice: 'Id3 genre was successfully created.' }
        format.json { render :show, status: :created, location: @id3_genre }
      else
        format.html { render :new }
        format.json { render json: @id3_genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /id3_genres/1
  # PATCH/PUT /id3_genres/1.json
  def update
    respond_to do |format|
      if @id3_genre.update(id3_genre_params)
        format.html { redirect_to @id3_genre, notice: 'Id3 genre was successfully updated.' }
        format.json { render :show, status: :ok, location: @id3_genre }
      else
        format.html { render :edit }
        format.json { render json: @id3_genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /id3_genres/1
  # DELETE /id3_genres/1.json
  def destroy
    @id3_genre.destroy
    respond_to do |format|
      format.html { redirect_to id3_genres_url, notice: 'Id3 genre was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_id3_genre
    @id3_genre = Id3Genre.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def id3_genre_params
    params.require(:id3_genre).permit(:name)
  end
end
