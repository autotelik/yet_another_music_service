# Data Service Center - Connectivity

Shared connectivity library.

Provides general wrappers around :

- MQ

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dsc_connectivity'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dsc_connectivity

There is a docker-compose.yml file provided with the definition of the service needed to create the  Rabbit MQ Server Container

This service includes the admin plugins, so you can access the admin UI and manage your queues via :

`http://localhost:15672`

## Usage

Base classes are provided, for implementing both Publishers and Consumers.

Connection details, such as the host, authorisation and queues are managed by a global ConnectionFactory class.

Consumers should implement a `process` method, which will receive the message (payload) and associated meta data (MqDataStruct) 

The specific queue they want to consume from, can be set in the initializer, using `connection_factory` helper,  as follows

```ruby
  class Jade < DscConnectivity::Mq::Consume::Base

    def initializ
      super( connection_factory.q(key: :dsc_consume_jade) )
    end
      
    def process(mq_data_struct)
      json_body = mq_data_struct.payload 
      ...
    end
```

Publishers can call the base class `publish_message` method with a payload and queue name.

For example

```ruby
   class ArtifactPublisher < DscConnectivity::Mq::Publish::Base

     def publish
       message = Message.new

       message[:some_field] = 'some data'
       message[:some_number] = 22

       publish_message(message, queue_name: connection_factory.q(key: :dsc_publish_artifcats) )
     end

```

### Rabbit MQ Configuration

The MQ configuration should be defined in `config/dsc_rabbitmq_config.yml`.

Define, the MQ Server host, login info and the queue names for publishing or consuming.

Multiple queues can be defined, using map of application key, to rabbit mq queue name. 

The services can be defined against the typical Rails environments, for example :

```yaml
development:
  host: rabbitmq.mapscape.nl
  user: guest
  password: guest
  port: 5672
  queues:
    dsc_consume_webmis: 'dsc_consume_webmis'
    dsc_consume_jade: 'dsc_consume_jade'

```

In your application code, you direct messages to a named queue, using ConnectionFactory singleton and the fixed key.

For example, to initialize a Consumer you can do something like :
 
```ruby  
        def initialize(queue_name: nil)
          super( queue_name: queue_name || connection_factory.q(key: :dsc_consume_jade) )
        end
```

For extra security, confidential information can be set in `.env` or [credentials.yml.enc](https://edgeguides.rubyonrails.org/security.html#custom-credentials) and then retrieved using erb templates in mq config

> Note When Rabbit MQ is running in docker, the IP address of a container (in this case named `dsc-rabbit-mq-server`),
can be retrieved as follows :

```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dsc-rabbit-mq-server
```

For example, more secure configuration using env and/or credentials: 
  
```yaml
production:
  host: <%= ENV['DSC_RABBITMQ_SERVER_HOST'] || system("docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dsc-rabbit-mq-server") %>
  user: <%= Rails.application.credentials.rabbitmq[:user] %>
  password: <%= Rails.application.credentials.rabbitmq[:password] %>
  port: 5672
```


The syntax to call out to the shell in dotenv is - `$(system cmd)` - for example:

```sh
export DSC_RABBITMQ_SERVER_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dsc-rabbit-mq-server)
```


