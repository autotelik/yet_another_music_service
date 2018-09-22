# frozen_string_literal: true

module Yams
  module CoverPresenter

    def cover_image_tag(size: :thumb, css: 'img-fluid rounded ')
      if cover.attached?
        view.image_tag(polymorphic_url(cover.image), class: css)
      else
        default = DefaultCover.for_track
        view.image_tag(polymorphic_url(default.image), class: css) if default.try(:image)
      end
    end

  end
end
