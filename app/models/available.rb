# frozen_string_literal: true

class Available < ApplicationRecord
  belongs_to :type, polymorphic: true, inverse_of: :availables

  enum concept: %i[radio commercial download playlist]

  before_create do
    self.on ||= DateTime.now
  end

end
