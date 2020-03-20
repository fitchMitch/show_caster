FROM ruby:2.4-stretch

# ENV RAILS_ENV production
ENV BUNDLER_VERSION=2.1.12

# RUN apk add --update --no-cache \
#       binutils-gold \
#       build-base \
#       curl \

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

# COPY package.json yarn.lock ./
# RUN yarn install --check-files

COPY . ./

RUN gem install foreman \
    && bundle install --deployment --without development test \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

ENTRYPOINT ./entrypoints/entrypoint.sh

