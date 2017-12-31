### Docker image for use with AWDWR 5.1 ###

# to push a new version:
# docker build -t anamba/awdwr .
# [test, fix, rebuild, retag until satisfied]
# docker tag anamba/awdwr:latest anamba/awdwr:5.1.1
# docker push anamba/awdwr

# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for a list of version numbers.
FROM phusion/passenger-ruby24
MAINTAINER aaronn@upspringmedia.com

# Set up 3rd party repos
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Update packages
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install other packages we depend on
RUN apt-get install -y \
  tzdata \
  nodejs yarn \
  curl git libmysqlclient-dev mysql-client \
  chromium-chromedriver \
  && apt-get autoremove -y

RUN ln -s /usr/lib/chromium-browser/chromedriver /usr/local/bin

WORKDIR /tmp

# Install bundler and rails
RUN gem install bundler -v '~> 1.16.0'
RUN gem install rails -v '~> 5.1.0'

# Preload the default gems
USER app
RUN bash -l -c 'rails new demoapp'

# Set up a simple .my.cnf
RUN echo "[client]\nhost = db" > /home/app/.my.cnf

# Enable services
# RUN rm -f /etc/service/nginx/down

# Copy in our vhost config, then remove the default vhost (so that ours will respond to any Host)
# COPY docker/nginx-vhost.conf /etc/nginx/sites-enabled/webapp.conf
# RUN rm -f /etc/nginx/sites-enabled/default

# Post-build clean up
USER root
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*
# RUN rm -rf /var/lib/apt/lists/*

# Put us back in homedir
WORKDIR /home/app

# Expose port 80 to the Docker host, so we can access it from the outside (remember to publish it using `docker run -p`).
EXPOSE 80
EXPOSE 3000

# Run this to start all services (if no command was provided to `docker run`)
CMD ["/sbin/my_init"]
