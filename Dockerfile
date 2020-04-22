FROM ruby:2.4-stretch
RUN apt-get update -qq \
    && apt-get install -y nodejs postgresql-client tzdata
# ENV RAILS_ENV production
ENV BUNDLER_VERSION=2.1.12

# RUN apk add --update --no-cache \
#       binutils-gold \
#       build-base \
#       curl \

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN echo "Europe/Paris" > /etc/timezone
RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install

# COPY package.json yarn.lock ./
# RUN yarn install --check-files

COPY . /app


COPY ./entrypoints/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
# RUN gem install rake \
#     && apt install -y nodejs \
#     && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
#     && bundle install --deployment --without development # test

# ENTRYPOINT ./entrypoints/entrypoint.sh

