FROM ruby:2.7.4

# Install dependencies
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Required 3rd party libs
# See also https://edgeguides.rubyonrails.org/active_storage_overview.html

RUN apt-get update -qq && \
    apt-get install -y apt-transport-https \
    ca-certificates \
    build-essential  \
    gnupg2 libpq-dev nodejs p7zip-full software-properties-common \
    vim \
    yarn

# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
ENV RUBYOPT='-W:no-deprecated -W:no-experimental'

## Create installation area for Rails app
#
ENV APP_HOME   /home/app/yams
ENV RAILS_ROOT /home/app/yams
WORKDIR $APP_HOME

RUN mkdir -p $APP_HOME && \
    mkdir -p $APP_HOME/tmp/pids

# Adding gems
COPY ./Gemfile ${APP_HOME}
COPY ./Gemfile.lock ${APP_HOME}

# We have private repos - need a Token
ARG GITHUB_TOKEN
RUN bundle config github.com x-access-token:${GITHUB_TOKEN} && \
    bundle config set without 'development' 'test' && \
    bundle install ${BUNDLE_INSTALL_ARGS}

## Copy the main application. (requires docker v17.09.0-ce and newer)
COPY . ${APP_HOME}

## Rails 6 with Webpacker - prepare assets for Production
RUN yarn install --check-files

RUN SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]



