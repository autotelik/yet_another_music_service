# frozen_string_literal: true

module DscConnectivity

  class MessageRef

    def self.generate
      SecureRandom.uuid
    end

  end
end
