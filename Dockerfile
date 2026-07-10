# Local development and test runs only — production runs on Heroku.
FROM ruby:3.4.6-slim

# build-essential/patch/zlib1g-dev/liblzma-dev: nokogiri builds from source
# (Gemfile.lock PLATFORMS is "ruby" only); libpq-dev: pg gem; libyaml-dev: psych.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential patch zlib1g-dev liblzma-dev libpq-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Match BUNDLED WITH in Gemfile.lock.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.7.2 && bundle install

COPY . .

# Haka-test example certs, referenced as $(cat cert/haka-test/...) in .env / .env.test
RUN [ -d cert/haka-test ] || { mkdir -p cert && cp -r doc/examples/haka-test cert/; }

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
