# Rails 5 - https://github.com/phusion/passenger-docker/blob/master/Changelog.md
FROM phusion/passenger-ruby25:0.9.35

# Check the Ubuntu version passenger image based on.
# RUN cat /etc/lsb-release
# Check the Ruby version passenger image based on.
#RUN ruby --version  && export

# Set correct environment variables.
ENV HOME /root

# Install everything requied to build native gems and run services - mlibsasl2-dev
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  curl libssl-dev \
  ffmpeg \
  git \
  gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x \
  unzip \
  zlib1g-dev \
  libxslt-dev \
  libqt5webkit5-dev \
  qt5-default \
  sqlite3

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Create installation area for Rails app - Passenger defines that it should be placed in /home/app.
ENV APP_HOME /home/app/yams
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Configure Nginx
# N.B - site specific config for /etc/nginx/sites-enabled/ is added via volume
RUN rm /etc/nginx/sites-enabled/default

# Start Nginx and Passenger
EXPOSE 80
RUN rm -f /etc/service/nginx/down

# Copy the main application.
COPY --chown=app:app .. ${APP_HOME}

RUN bundle install ${BUNDLE_INSTALL_ARGS}

