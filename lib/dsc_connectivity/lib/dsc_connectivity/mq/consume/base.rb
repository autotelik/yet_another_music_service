module DscConnectivity
  module Mq
    module Consume

      # Struct to hold the triplicate of objects routinely returned from MQ
      # Bunny::Queue#pop function returns a triple of [delivery_info, properties, payload]:

      MqDataStruct = Struct.new(:delivery_info, :properties, :payload) do

        def to_h
          ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(payload))
        end

        # if the queue is empty, low level pop returns all three as nil
        def empty?
          payload.blank? && delivery_info.blank? && properties.blank?
        end

      end

      # When a message is recievde, either via subscribe or pop, it will be dispatched to a method with signature :
      #
      #   process(mq_data_struct)
      #
      # So this is effectively a Virtual Method that derived Consumers must implement
      # to do the actual specific handling of a particular message type.
      #
      class Base

        include ::DscConnectivity::Mq::Logging

        attr_reader :connection

        delegate :queue, :channel, to: :connection

        def initialize(queue_name:)
          @connection =  DscConnectivity::Connection.new(queue_name)
        end

        # Shortcut to MQ Connection data
        def connection_factory
          DscConnectivity::ConnectionFactory.instance
        end

        # Options
        #  If you want non blocking thread, pass :block => false
        #
        #   :manual_ack (bool)    — default: true - Will this consumer use manual acknowledgements
        #   :block (Consume bool) — default: true - Should the call block calling thread?
        #
        #
        def subscribe(options = {})
          arguments = { block: true, manual_ack: true }.merge(options)

          puts('Subscribe to #{connection.qname} with options : ')
          pp arguments

          queue.subscribe(arguments) do |delivery_info, metadata, payload|
            puts("\nSUBSCRIBE: Message received on queue : [#{connection.qname}]")

            mq_data_struct = MqDataStruct.new(delivery_info, metadata, payload)

            process_mq_data(mq_data_struct)

            puts("END consuming message [#{delivery_info}]\n")
          end
        end

        def dispatch(mq_data_struct)
          process(mq_data_struct) # Virtual Method - Specific Q consumers should implement process
        end

        # Pop first message from q and return complete Context including delivery_info and metadata
        #
        def pop(manual_ack: true)
          MqDataStruct.new(*queue.pop(manual_ack: manual_ack))
        end

        # Pop first message from q and process
        #
        def pop_and_process
          data_struct = pop
          if data_struct.empty?
            puts 'Nothing to process - MQ empty'
          else
            process_mq_data(data_struct, sleep_for: 1)
          end
        end

        def payload_to_hash(payload)
          ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(payload))
        end

        private

        def process_mq_data(mq_data_struct, sleep_for: 10)

          delivery_info = mq_data_struct.delivery_info

          begin
            # TODO: - should we implement simple return codes, or wrap payload in a context which contains a status
            # or just rely on exceptions ??
            dispatch(mq_data_struct)

            channel.ack(delivery_info.delivery_tag)

            puts('Message processed ')
          rescue StandardError => x

            puts "NACK MQ - ERROR Processing Message : #{x.inspect}\n"

            # TODO: - how to make this optional ? Assumption now is we always want to requeue the message incase of failure
            multiple = false # Manual acknowledgements can be batched to reduce network traffic.
            requeue = true

            # With low message volume, this message will be immediately re-consumed and will create a requeue/redelivery loop

            # TODO: How to manage requeue after an appropriate delay ? How to manage permament removal after number of retries ?
            #
            # For now noddy sleep
            sleep(sleep_for)

            puts "Requeue Message\n"
            channel.nack(delivery_info.delivery_tag, multiple, requeue)
          end
        end
      end
    end
  end
end
