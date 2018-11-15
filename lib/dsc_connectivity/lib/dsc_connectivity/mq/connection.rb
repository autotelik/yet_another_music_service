# frozen_string_literal: true

module DscConnectivity
  class Connection
    include DscConnectivity::Mq::Logging

    attr_reader :qname, :queue, :channel, :connection

    # Defaults:
    #
    #   durable: true
    #   auto_delete: false
    #
    # Options :
    #   :durable =>  true/false :
    #   :exclusive  =>  true/false : Should this queue be exclusive (only can be used by this connection, removed when the connection is closed)?
    #   :auto_delete => true/false : Should this queue be automatically deleted when the last consumer disconnects?
    #   :arguments  — default: {} — Additional optional arguments (typically used by RabbitMQ extensions and plugins)

    def initialize(qname, options = {})
      raise StandardError, 'No queue name specified- cannot complete connection' unless qname.present?

      @qname = qname

      rabbitmq_server_url = ConnectionFactory.instance.rabbitmq_server_url

      unless rabbitmq_server_url
        puts('No MQ connection settings - did you set .env ?')
        raise StandardError, 'No MQ connection settings - did you set .env ?'
      end

      puts("Start MQ Connection on Server : #{rabbitmq_server_url}")

      @connection = Bunny.new(rabbitmq_server_url)

      @connection.start

      @channel = @connection.create_channel

      puts("Opening queue : #{qname}")

      durable     = options.key?(:durable)     ? options[:durable] : true
      auto_delete = options.key?(:auto_delete) ? options[:auto_delete] : false
      exclusive   = options.key?(:exclusive)   ? options[:exclusive] : false

      puts("Queue  config:\n\tdurable: #{durable}\n\tauto_delete: #{auto_delete}\n\texclusive: #{exclusive}")

      begin
        @queue = @channel.queue(qname, durable: durable, auto_delete: auto_delete, exclusive: exclusive)
      rescue StandardError => x
        puts "Failed to create Q on MQ Server [#{rabbitmq_server_url}]"
        puts x.message, x.backtrace
        raise StandardError, "Failed to create Q on MQ Server [#{rabbitmq_server_url}]"
      end
    end

    def publish(payload, persistent: true)
      begin
        channel.default_exchange.publish(payload, routing_key: @queue.name, persistent: persistent)
      rescue StandardError => x
        puts("Failed to publish message to #{qname}")
        puts(x.inspect)
        raise x
      end

      puts("Message published to : #{qname}")
    end

    def size
      @channel.queue_declare(qname, passive: true).message_count
    end

    alias message_count size

    def method_missing(method_name, *args)
      if queue && queue.respond_to?(method_name)
        queue.send(method_name, *args)
      else
        super
      end
    end
  end
end
