# HYY Voting API (Rails / Grape)

API backend for the HYY Voting Service.

Has [Voting-frontend](https://github.com/hyy-vaalit/voting-frontend) included as a git submodule
in public/ folder.

API endpoints per 09/2016 are the following (`rake grape:routes`):

| VERB | URI                                                          | Description
| ---- | ------------------------------------------------------------ | ------------------------------------------------------
| GET  | /api/elections/:election_id/voting_right(.json)              | Tells whether user can cast a vote in current election
| POST | /api/elections/:election_id/vote(.json)                      | Cast a vote for a candidate
| GET  | /api/elections/:election_id/coalitions(.json)                | Get coalitions, include candidates using :with_candidates=true
| GET  | /api/elections/:election_id/alliances(.json)                 | Get alliances for an election
| GET  | /api/elections/:election_id/candidates(.json)                | Get all candidates for an election
| POST | /api/sessions(.json)                                         | Grant a new session JWT
| GET  | /api/pling(.json)                                            | Returns public plong.
| GET  | /api/export/elections/:election_id/summary(.json)            | GET metadata of current election
| GET  | /api/export/elections/:election_id/votes(.:format)           | GET votes of current election
| POST | /api/sessions/link(.json)                                    | Send a sign-in link for the voter.
| POST | /api/elections/:election_id/voters(.json)                    | Create a new voter
| GET  | /api/elections/:election_id/voters(.json)                    | List voters created after elections have started
| GET  | /api/public/elections/:election_id/voting_percentage(.json)  | GET voting percentage rounded to one decimal.


## Access Levels and Authorization

Permissions to API endpoints are defined in `app/models/ability.rb`.

User types explained:

* Unauthenticated user
  * `app/models/guest_user.rb`
  * Any user who does not provide a valid JWT API Token.
  * Can create a new JWT session token.

* Authenticated voter
  * `app/models/user.rb` represents info in the JWT API Token.
  * `app/models/voter.rb` represents the actor behind `User`.
  * A voter who has completed either a Haka authentication or provides a
    Sign In Link which is sent by email.
  * Can cast a vote.
  * Can access information related to the elections.

* Authenticated backend service
  * `app/models/service_user.rb`
  * A trusted backend service (eg. Vaalitulostin).
  * Can create voters during the election.
  * Can email a Sign In Token to a Voter created during the elections.
  * Can export votes after the elections.


## Setup

Install [Ruby Version Manager (RVM)](https://rvm.io/).
  * After RVM is installed, re-enter the project directory
    in order to apply `.ruby-version` and `.ruby-gemset`.
  * If all is good, config in above mentioned files matches with:
    - `gem env`
    - `which ruby`

Retrieve the Angular.js frontend (needed for production use only):
  * `git submodule update --init`
  * This installs a static copy of
    [compiled Angular.js frontend](https://github.com/hyy-vaalit/voting-frontend-dist)
    to public/

Set up local version of the [Angular.js frontend](https://github.com/hyy-vaalit/voting-frontend)
which will be run in a _different port_ than the Rails server.
Note that there are also two different Frontend repositories:
`hyy-voting-frontend` and `hyy-voting-frontend-dist`.

Install Gem dependencies:
  * `gem install bundler` (needs only be done once)
  * `bundle install`

Configure `.env`
  * `cp .env.example .env`
  * copy test certificates from `doc/certificate_examples`, these can be used
    with Haka-test for authentication.

Quick setup for dev database:
  * `rake db:runts && rake db:seed:edari`

Manual setup for dev database:
```bash
rake db:create
rake db:schema:load
rake -T db:seed
```

Open a SSL tunnel in order to sign in with a Haka test account:
  * `npm install -g local-ssl-proxy`
  * `local-ssl-proxy --source 3001 --target PORT`
  * PORT is either 3000 in development (`.env`) or 3999 in test (`.env.test`)


## Configure your Editor:

* Install Rubocop linter plugin which will lint Ruby on the fly,
  * Atom: `linter-rubocop`
  * https://buildtoship.com/integrate-rubocop-in-your-workflow/
  * Define exceptions in `.rubocop.yml`
  * Generate a TODO list of pending lints:
    `rubocop --auto-gen-config`


## Run dev server

`rails s`

Example user:
testi.pekkanen@example.com (sign-in link via email)
teppo/testaaja (Haka-test)


## List API endpoints:

* Rails routes: `rake routes`
* API Routes: `rake grape:routes`


### Generate a sample JWT authorization token

ServiceUser (for internal services, eg. Vaalitulostin)
* `rake jwt:service_user:generate [expiry_hours=24] [payload=anything]`

Voter (person who accesses the frontend)
* `rake jwt:voter:generate [expiry_hours=24] [voter_id=1]`

Verify token contents:
* `rake jwt:service_user:verify jwt=JWT_TOKEN`
* `rake jwt:voter:verify jwt=JWT_TOKEN`

Heroku:
* `heroku run rake jwt:voter:generate voter_id=1`


## Testing

* Test with Chrome:
  * Install Chrome
  * Install [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/downloads)
  * Mac: `brew update && brew install chromedriver`

* To test with Firefox:
  * Install Firefox
  * Install [Geckodriver](https://github.com/mozilla/geckodriver/releases)
  * Browser tests to Haka auth fail with Firefox due to SSL certificate error.
    See spec_helper for details.

* Run tests and Watch changes:
`guard`

* Run tests once (provide filename to run an individual test):
`rspec`

* You may run a specific test using `focus: true` in the test description.
  - You can also use aliases `fit`, `fcontext` and `fdescribe` respectively.

* To run Haka browser tests:
  - `npm install -g local-ssl-proxy`
  - `local-ssl-proxy --source 3001 --target 3000`
  * NOTE: If the Haka authentication browser fails because of Mozilla security
    exception, you'll need to manually add https://localhost.enemy.fi:3001 to
    the Firefox security whitelist. Certificate Error page > Advanced > Add
    Exception > https://localhost.enemy.fi:3001.
  * Haka local test endpoint is registered as `hyy.voting.test.local` in
    rr.funet.fi.


## Heroku

### Dump database

```bash
pg_dump -d $(heroku config:get DATABASE_URL --app hyy-vaalit) -c -O -f dump.sql
psql -d hyy_api_development -f dump.sql
```

### Environment variables

Configure environment values at once:
- `cp .env.example .env.deploy`
- edit .env.deploy
- Run `bin/env_for_heroku_config.sh .env.deploy`

Multiline values (certificates) should be set as follows:
  `heroku config:set SOME_CERT="$(cat cert.pem)"`


## Tips

* Reset your voting right to vote multiple times:
  - `VotingRight.find(X).update! used: false`

* SessionLink#deliver() will send email during HTTP request.
  This could be made to happen in the background.

* Error with Capybara tests: "unable to obtain stable firefox connection in 60 seconds (127.0.0.1:7055)"
  - Update Selenium, Firefox or Geckodriver so that the combination of their versions works.

* If you get any OpenSSL error about the certificates, double check the line endings.
  Use eg. `puts Vaalit::Haka::SAML_IDP_CERT` in `rails console` to see that
  all lines have equal width.
  - example error: `OpenSSL::X509::CertificateError: nested asn1 error`
  - Try in `rails console`:
```ruby
# This should print "-----BEGIN CERTIFICATE-----\n[....]-----END CERTIFICATE-----\n"
# Ensure there is a newline in `-----END CERTIFICATE-----\n`
cert = File.read("cert/haka-test.crt")

# Check that every line width is equal
puts cert

# Check if OpenSSL can open the certificate
# Use `OpenSSL::PKey::RSA.new rsa_key` for a private key
OpenSSL::X509::Certificate.new cert
```

## Testing in Heroku

* Set Heroku environment variables with newlines (ie. certificates) using:
  - `heroku config:add SOME_CERT="$(cat cert.pem)"`
  - WONT WORK: `heroku config:set XYZ="has\nnewlines"`, it will mess up `\n` to `\\n`.

* Reset Heroku database:
  - `heroku pg:reset DATABASE`
  - `heroku run rake db:schema:load`

* A) Seed using data from Ehdokastietojärjestelmä
  - `heroku run rake db:seed:common`
  - `heroku run rake db:seed:edari`
  - Example seeds are available in the admin dashboard of Ehdokastietojärjestelmä

  * Production seed data is loaded to Heroku from interactive terminal.
    There's [an issue in heroku-toolbelt](https://github.com/heroku/heroku/issues/1409)
    which prevents using eg.
    `heroku run rake db:seed:edari:candidates < candidates.csv`.

* B) Seed demo data without votes:
  - `heroku run rake db:seed:edari:demo`

* Generate a login token:
  - `heroku run rake jwt:voter:generate expiry_hours=1000 voter_id=1`

* Access console:
  `heroku console`

* Access logs:
  `heroku logs --tail`
