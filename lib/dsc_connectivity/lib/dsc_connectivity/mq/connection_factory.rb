# frozen_string_literal: true

module DscConnectivity
  class ConnectionFactory
    include Singleton

    attr_reader :configurations, :connection

    def rabbitmq_server_url
      "amqp://#{connection[:user]}:#{connection[:password]}@#{connection[:host]}:#{connection[:port]}"
    end

    def create_queue(queue_name)
      DscConnectivity::Connection.new(queue_name)
    end

    def q(key:, env: nil)
      qname = queues(env: env)[key]
      raise DscConnectivity::Mq::ConfigParse, "No entry found for queue with key: #{key} in Config" unless qname
      qname
    end

    def queues(env: nil)
      conn = env ? @configurations[env] : @connection
      ActiveSupport::HashWithIndifferentAccess.new( conn.fetch(:queues, {}) )
    end

    private

    def initialize
      @configurations = ActiveSupport::HashWithIndifferentAccess.new
      @connection     = ActiveSupport::HashWithIndifferentAccess.new

      parse_yaml
    end

    def parse_yaml
      path = ENV.fetch('DSC_RABBITMQ_CONFIG', File.join(Rails.root, 'config', 'dsc_rabbitmq_config.yml'))

      return unless File.exists?(path)

      raw_template = begin
        ERB.new(IO.read(path))
      rescue StandardError => e
        raise DscConnectivity::Mq::ConfigParse, "Parse error in Rabbit MQ Config [#{e.inspect}]"
      end

      bound_template = begin
        raw_template.result
      rescue StandardError => e
        raise DscConnectivity::Mq::ConfigParse, "ERB Binding Error in Rabbit MQ Config [#{e.inspect}]"
      end

      @configurations = ActiveSupport::HashWithIndifferentAccess.new(YAML.safe_load(bound_template, [Date, Time, Symbol] ))

      @connection = ActiveSupport::HashWithIndifferentAccess.new(@configurations[Rails.env])
    end


  end
end
