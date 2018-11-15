# frozen_string_literal: true

module DscConnectivity
  module Mq
    module Logging
      # Want an MQ specific logger, separate from the website stuff

      class << self
        def name=(x)
          @logger = Logger.new(Rails.root.join('log', x))
          @logger.formatter = Logger::Formatter.new
        end

        def logger
          unless @logger
            @logger = Logger.new(Rails.root.join('log', 'mq.log'))
            @logger.formatter = Logger::Formatter.new
          end
          @logger
        end

        attr_writer :logger
      end

      def self.included(base)
        class << base
          def logger
            DscConnectivity::Mq::Logging.logger
          end
        end
      end

      def logger
        DscConnectivity::Mq::Logging.logger
      end
    end
  end
end
