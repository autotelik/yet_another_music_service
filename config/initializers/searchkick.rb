Searchkick.redis = ConnectionPool.new { Redis.new }

Searchkick.client_options = {
  url: ENV.fetch('ELASTICSEARCH_URL', 'http://localhost:9200'),
  retry_on_failure: true,
  transport_options:
    {
      request: {
        timeout: 250
      }
    }
}
