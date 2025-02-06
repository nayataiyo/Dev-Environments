FROM ruby:3.3.6
ENV APP_ROOT=/var/www/app
WORKDIR $APP_ROOT

RUN mkdir -p /var/run/puma

RUN curl https://deb.nodesource.com/setup_16.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    locales \
    vim \
    nodejs \
    redis-tools \
    yarn \
    mariadb-client && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# setting locales
RUN localedef -f UTF-8 -i en_US en_US.UTF-8

# Setup UTC+9
RUN cp -p /etc/localtime /etc/localtime.UTC \
    && cp -p /usr/share/zoneinfo/Japan /etc/localtime

RUN gem install bundler -v 2.5.23
COPY Gemfile Gemfile.lock $APP_ROOT
RUN bundle install

# yarn install Preparation
RUN npm install n -g
RUN n 23.4.0
RUN yarn install

EXPOSE 80
CMD ["bundle", "exec", "puma", "-C", "config/dev_puma-socket.rb", "-e", "development"]
