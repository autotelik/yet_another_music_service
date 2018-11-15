module DscConnectivity
  module Mq
    class DscException < StandardError
      def initialize(msg)
        super
        Rails.logger.error(msg)
      end

      def self.generate(name)
        new_class = Class.new(DscException) do
          def initialize(msg)
            super(msg)
          end
        end

        DscConnectivity::Mq.const_set(name, new_class)
      end
    end
  end
end

# Self logging errors
DscConnectivity::Mq::DscException.generate('NACKQueue')
DscConnectivity::Mq::DscException.generate('ConfigParse')