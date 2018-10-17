# frozen_string_literal: true

module Yams
  module AvailableFor
    extend ActiveSupport::Concern

    included do
      has_many :availables, as: :type, dependent: :destroy, inverse_of: :type

      accepts_nested_attributes_for :availables, allow_destroy: true

      scope :for_radio, -> { joins(:availables).where('availables.mode': Available.concepts[:radio]) }
      scope :for_commercial, -> { joins(:availables).where('availables.mode': Available.concepts[:commercial]) }
    end

    def available_for?(mode)
      # TODO: should we check if mode is already an integer ?
      availables.where(type: self, mode: Available.concepts[mode]).count > 0 # TODO: most efficient way ?
    end

    def make_available_for(mode)
      save! if new_record?
      availables.create!(mode: Available.concepts[mode])
    end

  end
end
