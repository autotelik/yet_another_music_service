# frozen_string_literal: true

module Yams
  class Presenter < SimpleDelegator

    attr_reader :view
    attr_reader :model

    # Enable Presenters to access view helpers too
    #
    include Rails.application.routes.url_helpers

    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    include ApplicationHelper

    def initialize(model, view)
      super(model)
      @view = view
      @model = model
    end

  end
end
