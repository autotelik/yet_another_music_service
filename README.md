Yet Another Music Service
================

An open source  music streaming service, band page or record store.

#### Installation

### Manual

Clone from github

This application requires:

- Ruby 2.5
- Rails 5
- Elastic search with Kibana - [Installation instructions](https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html) - or see docker section below.
- Sidekiq and Redis

These are already bundled as services, configured to inter operate, in our docker compose setup. 

Elastic search will be available at : `http://localhost:9200`

Kibana will be available at : `http://localhost:5601` 

To manually install Redis locally see  : `https://redis.io/topics/quickstart`

To start them locally, run from the root of the application:

```sh
redis-server

bundle exec sidekiq
```

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

In your cloned project, install the gems

```sh
bundle install
```

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

You can open a bash sh in the container and jump to seed the DB section.
```sh
 docker exec -ti development bash
```
Elastic search will be available at : `http://localhost:9200`

Kibana will be available at : `http://localhost:5601` 

### DB Setup

We use .env to manage configuration, including DB access.

Copy .env.example to .env and edit, supplying your DB credentials. Current config is setup to use postgres.

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

Example data can be bulked uploaded from Excel spreadsheet containing details of tracks and covers

```ruby
thor yams:db:seed_music

wrapper around - TODO create dropbox link in excel so anyone can dopwnload the actual mp3s

thor datashift:import:excel -i  db/seed/aqwan_tracks.xls -m Track -c lib/tasks/config/track_import.yaml 
```



### Development

If hosting your own YAMS, you probably first want to change the `front_page` and `about` pages. 

These can be found under : `app/views/pages`

We use mailcatcher but is not present inr Gemfile since it will conflict with your applications gems at some point.

Simply run `gem install mailcatcher` then `mailcatcher` to get started.


Documentation and Support
-------------------------

The app and associated applications can be spun up via Docker


Similar Projects
----------------

Contributing
------------

If you'd like to contribute, please fork the repository and make changes as you'd like. Pull requests are warmly welcome.

Credits
-------

License
-------
@copyright thomas statter @ autotelik

open source