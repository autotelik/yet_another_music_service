# frozen_string_literal: true

Rails.application.configure do
  # ELK
  #   - https://github.com/dwbutler/logstash-logger

  # See everything in the log (default is :info)
  # config.logger = LogStashLogger.new(type: :file, path: 'log/development.log')
  config.lograge.enabled = true

  # Optional. Defaults to :json_lines. If there are multiple outputs,
  # they will all share the same formatter.
  config.logstash.formatter = :json_lines

  config.lograge.formatter = Lograge::Formatters::Logstash.new

  logger = LogStashLogger.new(type: :udp, host: 'logstash', port: 5228, sync: true)

  config.logger = logger
  config.lograge.logger = logger

  # TODO: - this setting fo development, not suitable for production
  config.log_level = :verbose

  # Optional, defaults to '0.0.0.0'
  config.logstash.host = '0.0.0.0'

  # Optional, defaults to :udp.
  config.logstash.type = :udp

  # - Possible to maybe have ELK and usual file
  #
  #   config.logstash.type = :multi_logger
  #
  #   # Required. Each logger may have its own formatter.
  #   config.logstash.outputs = [
  #     {
  #       type: :file,
  #       path: 'log/production.log',
  #       formatter: ::Logger::Formatter
  #     },
  #     {
  #       type: :udp,
  #       port: 5228,
  #       host: 'localhost'
  #     }
  #   ]

  # COMMON

  # Required, the port to connect to
  config.logstash.port = 5228

  # Optional, Rails 4 defaults to true in development and false in production
  config.autoflush_log = true

  # Optional, the logger to log writing errors to. Defaults to logging to $stderr
  config.logstash.error_logger = LogStashLogger.new(type: :udp, host: 'logstash', port: 5228)

  # Optional, max number of items to buffer before flushing. Defaults to 50
  config.logstash.buffer_max_items = 50

  # Optional, max number of seconds to wait between flushes. Defaults to 5
  config.logstash.buffer_max_interval = 5

  # Optional, drop message when a connection error occurs. Defaults to false
  config.logstash.drop_messages_on_flush_error = false

  # Optional, drop messages when the buffer is full. Defaults to true
  config.logstash.drop_messages_on_full_buffer = true
end
