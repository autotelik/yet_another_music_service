# frozen_string_literal: true

module Yams
  module Covering
    extend ActiveSupport::Concern

    included do
      has_one_attached :image#, styles: { medium: '340x340>', small: '160x160>', thumb: '100x100>' }
      # TODO validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

      validates_presence_of :image
    end

    def attached?
      image.try(:attached?)
    end

  end
end
