# frozen_string_literal: true

class DefaultCover < ApplicationRecord

  include Yams::Covering

  enum kind: %i[album artist playlist track user]

  DefaultCover.kinds.each do |name, idx|
    define_singleton_method ("for_#{name}") { where(kind: idx).first }
  end

end
