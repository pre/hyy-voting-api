# HYY Voting API (Rails / Grape)

## Setup

Retrieve the Angular.js frontend (needed for production use only):
* `git submodule update --init`
* This installs a static copy of
  [compiled Angular.js frontend](https://github.com/pre/hyy-voting-frontend-dist)
  to public/

Set up local version of the [Angular.js frontend](https://github.com/pre/hyy-voting-frontend)
which will be run in a _different port_ than the Rails server.

Install Gem dependencies:
* `gem install bundler` (needs only be done once)
* `bundle install`

Configure `.env`
* `cp .env.example .env`

Setup dev database:

Quick:
`rake db:runts`

Manual:
~~~
rake db:create
rake db:schema:load
rake db:seed:base
rake db:seed
~~~

## Run

`rails s`

Example user:
testi.pekkanen@example.com

## List API endpoints:

Rails routes: `rake routes`
API Routes: `rake grape:routes`

## Heroku

### Dump database

pg_dump -d $(heroku config:get DATABASE_URL --app hyy-vaalit) -c -O -f dump.sql
psql -d hyy_api_development -f dump.sql


## Testing

Run tests and Watch changes:
`guard`

Run tests once (provide filename to run an individual test):
`rspec`


## Tips

* Get a JWT token:
  `curl -X POST -H "Content-Type: application/json" http://localhost:3000/api/sessions/link -d '{"email": "testi.pekkanen@example.com" }'`

* There's a test helper Requests::JsonHelpers which will automatically `JSON.parse(response.body)`
