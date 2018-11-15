# frozen_string_literal: true

class Available < ApplicationRecord
  belongs_to :type, polymorphic: true, inverse_of: :availables

  enum concept: %i[free commercial download playlist]

  before_create do
    self.on ||= DateTime.now
  end

  after_create do
    AnnounceAvailableCreatedWorker.perform(self)
  end

end
