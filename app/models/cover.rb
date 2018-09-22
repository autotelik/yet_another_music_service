# frozen_string_literal: true

class Cover < ApplicationRecord
  include Yams::Covering

  belongs_to :owner, polymorphic: true, required: false

end
