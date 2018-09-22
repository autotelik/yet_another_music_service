# frozen_string_literal: true

class SearchesController < ApplicationController

  def show
    query = search_params[:q].to_s.strip

    results = {
        track: Track.search(query, page: params[:page], per_page: 20),
        album: Album.search(query, page: params[:page], per_page: 20)
    }

    @search_results = SearchPresenter.new(results, view_context)
  end

  private

  def search_params
    params.require(:searches).permit(:q)
  end

end
