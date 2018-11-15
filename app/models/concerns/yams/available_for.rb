# frozen_string_literal: true

module Yams
  module AvailableFor
    extend ActiveSupport::Concern

    included do
      has_many :availables, as: :type, dependent: :destroy, inverse_of: :type

      accepts_nested_attributes_for :availables, allow_destroy: true

      scope :for_free, -> { joins(:availables).where('availables.mode': Available.concepts[:free]) }
      scope :for_commercial, -> { joins(:availables).where('availables.mode': Available.concepts[:commercial]) }
    end

    def available_for?(mode)
      # https://semaphoreci.com/blog/2017/03/14/faster-rails-how-to-check-if-a-record-exists.html
      availables.where(type: self, mode: Available.concepts[mode]).exists?
    end

    def make_available_for(mode)
      save! if new_record?
      availables.create!(mode: Available.concepts[mode])
    end

  end
end
