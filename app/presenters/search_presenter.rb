# frozen_string_literal: true

class SearchPresenter < Yams::Presenter

  def initialize(results, view)
    super(results, view)
  end

  alias search_results model

end
