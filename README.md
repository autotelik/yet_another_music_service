Yet Another Music Service - Front End
================

Demonstration of an open source music streaming service, band page or record store.

### Run your own

This is a front end example APP, that utilises the core functionality of YAMS, which is provided in a separate open source [ yams core engine](https://github.com/autotelik/yams_core)
 
You are welcome to use this project as the basis for your very own yet another music service.
 
After forking this repository, you probably want to :

- Create your own `front_page` and `about` pages. 

These can be found under : `app/views/pages`

## Installation

The whole app can be spun up on your host using Docker - see the provided Docker compose setup.

The following instructions are for a non docker install or for a development setup.

### Prerequisites

This application requires:

- Ruby > 2.7
- ElasticSearch, Kibana - [Installation instructions](https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html) - or see docker section below.
- Postgres, Sidekiq and Redis

You will also need a Javascript runtime - see : https://github.com/rails/execjs
Node.js (v14) is usually a good option : https://github.com/nodesource/distributions/blob/master/README.md

To manage javascript assets, we use webpacker and *yarn* 

[Yarn Installation instructions](https://yarnpkg.com/getting-started/install)

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

In your cloned project, install the gems and dependencies :

```sh
bundle install

yarn install
```

The suite of additional services can also be spun up using Docker and accessed by the app.

## Configuration

The .env file can be used to configure certain aspects of the setup - see `.env.example`

Database connection details can be set in here, or in Rails encrypted secrets - see config/database.yml

Uploaded image and audio files are stored using Active Storage.

In config/environments/development.rb the service is set to `:local` by default, and the local storage path
is defined by ENV : YAMS_LOCAL_STORAGE_PATH

In Production, follow Active Storage's usual configuration and set your preferred cloud storage in : `config/storage.yml`

## Docker

A Dockerfile and docker-compose file are provided to simplify installation.

The complete stack, for a `development` container, can be spun up with a single thor command :

```sh
bundle exec thor yams:docker:dev
```

Pass `--init` if you would like to also create and seed the DB.

> Elastic Search container may exit first time, with log containing :

```
ERROR: [1] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

>RESOLUTION : Run : `sudo sysctl -w vm.max_map_count=262144`

Elastic search will be available at : `http://localhost:9200`

Kibana will be available at : `http://localhost:5601` 

Sidekick configuration, including list of queues to start can found here : `docker/config/sidekiq.yml`

### Foreman

In **development** you can use [Foreman](http://blog.daviddollar.org/2011/05/06/introducing-foreman.html) to start all
of the processes associated with the app and display stdout and stderr of each process.

This should not go in Gemfile - so install manually.
`gem install foreman`

To start all servers :

`foreman start -f Procfile.dev`

Otherwise, start the web server on port 3000

`bundle exec rails server`

And start the webpacker server

`bin/webpack-dev-server`


To manually install Redis locally see  : `https://redis.io/topics/quickstart`

To start locally, run from the root of the application:

```sh
redis-server

bundle exec sidekiq
```

### DB Setup

If using the docker install, the DB container should be ready to use,if you wish to use the seed data,
open a bash sh in the container and jump to the section Seed the DB

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

The admin user is created via `db:seed` task. You can specify the email and password in `.env`

In development seed will also create an artist User

email: 'artist@example.com'
password: 'artist_change_me'
 
 ```ruby
rails db:seed
```

##### Loading Sample Audio Data

Audio files and associated details can be **bulk uploaded** from an Excel spreadsheet containing details of tracks and covers.

There is a starter pack of music and images available for free, by visiting this link

[Free Sample Pack](https://www.dropbox.com/sh/ofk927xx4f3kvww/AADNZHYVedH7-3eQNVRR10VVa?dl=1)

If download does not start automatically, there should be a Download button top right.

Save zip and extract contents to `/tmp` on your local hard drive: 

> If you save elsewhere, open up the loading spreadsheet, `db/seed/aqwan_tracks.xls`, and change the `/tmp` 
> path that's hardcoded in there.
 
> The development artist user is assigned by default in the spreadsheet, again edit in the spreadsheet to change.

Run

```ruby
thor yams:db:seed_music
```

This is essentially a wrapper around an Excel import tool for Rails. 

If you want to load your own, the raw command would be :

```
thor datashift:import:excel -i <spreedsheet>.xls -m Track -c lib/tasks/config/track_import.yaml 
```

Contributing
------------

If you'd like to contribute, please fork the repository and make changes as you'd like. Pull requests are warmly welcome.

Credits
-------

License
-------
@copyright aqwan @ autotelik

open source

[Free Sample Pack]: https://www.dropbox.com/sh/ofk927xx4f3kvww/AADNZHYVedH7-3eQNVRR10VVa?dl=1