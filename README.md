Yet Another Music Service - Front End
================

Demonstration of an open source music streaming service, band page or record store.

### Run your own

This is a front end example APP, that utilises the core functionality of YAMS, which is provided in the engine -
 
You are welcome to use this as a basis or template for your own music service.
 
After forking this repository, you probably want to :

- Create your own `front_page` and `about` pages. 

These can be found under : `app/views/pages`

#### Installation

This application requires:

- Ruby 2.5
- Rails 5
- ElasticSearch, Kibana - [Installation instructions](https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html) - or see docker section below.
- Sidekiq and Redis

These are already bundled as services, configured to inter operate, in provided Docker compose setup. 

Clone the Project from github

In your cloned project, install the gems

```sh
bundle install
```

### Prerequisites

Some mp3 processing currently requires ffmpeg

For Ubuntu
```
sudo apt install ffmpeg
```

File uploads require imagemagick

For Ubuntu

```sh
sudo apt-get install imagemagick
```

We use mailcatcher but is not present in Gemfile since it will conflict with your applications gems at some point.

Simply run `gem install mailcatcher` then `mailcatcher` to get started.


### Docker

A Dockerfile and docker-compose file are provided to simplify installation.

There is a docker specific database.yml file that is copied into the container under docker/config/database.yml

The complete stack, for a `development``container, can be spun up with a single thor command :

```sh
bundle exec thor yams:docker:dev:up
```

> Elastic Search container may exit first time, with log containing :

```
ERROR: [1] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

>RESOLUTION : Run : `sudo sysctl -w vm.max_map_count=262144`

Elastic search will be available at : `http://localhost:9200`

Kibana will be available at : `http://localhost:5601` 

Sidekick configuration, including list of queues to start can found here : `docker/config/sidekiq.yml`

### Manual

To manually install Redis locally see  : `https://redis.io/topics/quickstart`

To start them locally, run from the root of the application:

```sh
redis-server

bundle exec sidekiq
```


### DB Setup

If using the docker install, DB container should be ready to use,if you wish to use the seed data,
open a bash sh in the container and jump to seed the DB section.

```sh
 docker exec -ti development bash
```

For manual installs, we use .env to manage configuration, including DB access.

Copy .env.example to .env and edit, supplying your DB credentials. Current config is setup to use postgres.

Standard Rails DB stuff applies to create, migrate and seed the DB.

```ruby
rake db:create
rake db:migrate
```

#### Seed the DB

The admin user is created via db:seed task with password specified in .env

In development seed will also create an artist User

email: 'artist@example.com'
password: 'artist_change_me'
 
 ```ruby
rake db:seed
```

- Login

- Change admin password !

##### Loading Sample Audio Data

Example data can be bulked uploaded from Excel spreadsheet containing details of tracks and covers.

There is a starter pack of my music and images available Free, click the Download button (top right), 
and save o local hard drive, via this link : 

- 

Save the contents to `/tmp` - which is the path hardcoded in the loading spreadsheet : `db/seed/aqwan_tracks.xls`
 
>The development artist user is assigned by default in the spreadsheet, so edit this to assign tracks to a different user.

Run

```ruby
thor yams:db:seed_music
```

This is essentially a wrapper around an Excel import tool for Rails. If you want to load your own, the raw command would be :

```
thor datashift:import:excel -i  db/seed/aqwan_tracks.xls -m Track -c lib/tasks/config/track_import.yaml 
```

Contributing
------------

If you'd like to contribute, please fork the repository and make changes as you'd like. Pull requests are warmly welcome.

Credits
-------

License
-------
@copyright thomas statter @ autotelik

open source