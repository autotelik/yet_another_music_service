# frozen_string_literal: true

module DscConnectivity
  module Mq
    module Publish
      class Base
        include ::DscConnectivity::Mq::Logging

        attr_accessor :publish_object

        def initialize(publish_object: nil)
          @publish_object = publish_object
        end

        # Shortcut to MQ Connection data
        def connection_factory
          DscConnectivity::ConnectionFactory.instance
        end

        # Publish the message to MQ
        #
        def publish_message(message, queue_name:, persistent: true)
          byebug
          # Get a publishable (string) form
          payload = message.is_a?(DscConnectivity::Message) ? message.for_mq : message

          begin
            # TODO: ensure we're using a durable queue and durable message, and that
            # message only removed from queue on receiving ACK i.e other side calls basic_ack
            connection = connection_factory.create_queue(queue_name)

            Rails.logger.info("Writing message to MQ #{queue_name}")

            connection.publish(payload, persistent: persistent)
          rescue StandardError => x
            puts("Message [#{message.message_id}] could not be published to #{queue_name}")
            puts(x.inspect)
            puts(x.backtrace.join("\n"))
          end
        end
      end
    end
  end
end
