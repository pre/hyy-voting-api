# HYY Voting API (Rails / Grape)

## Setup

`git submodule update --init`

`bundle install`

Configure `.env` (see `.env.example`)

~~~
rake db:create
rake db:schema:load
rake db:seed:base
rake db:seed
~~~

## Run

`rails s`

## Heroku

### Dump database

pg_dump -d $(heroku config:get DATABASE_URL --app hyy-vaalit) -c -O -f dump.sql
psql -d hyy_api_development -f dump.sql
