# HYY Voting API (Rails / Grape)

API backend for the HYY Voting Service.

Has [Voting-frontend](https://github.com/hyy-vaalit/voting-frontend) included as a git submodule
in public/ folder.

API endpoints per 11/2020 are the following (`rake grape:routes`):

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
| GET  | /api/stats/votes_by_hour(.json)                              | GET voting percentage by hour [1]
| GET  | /api/stats/votes_by_faculty(.json)                           | GET voting percentage by faculty [2]
| GET  | /api/stats/votes_by_voter_start_year(.json)                  | GET voting percentage by voter start year

[1] = Data should be published with a delay during the elections.
[2] = Returns vote count per faculty as 0 during the elections.


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
  * Can fetch statistics during the election.


## Setup

Install [Ruby Version Manager (RVM)](https://rvm.io/).
  * After RVM is installed, re-enter the project directory
    in order to apply `.ruby-version` and `.ruby-gemset`.
  * If all is good, config in above mentioned files matches with:
    - `gem env`
    - `which ruby`

Install correct version of ruby (cat .ruby-version)
  * rvm install N.N.N --with-openssl-dir=$(brew --prefix openssl@3)
  * The --with-openssl-dir is needed if both OpenSSL 1 and 3 versions are installed

Retrieve the distribution of voting-frontend (needed for production use only):
  * `git submodule update --init`
  * This installs a static copy of
    [voting-frontend distribution](https://github.com/hyy-vaalit/voting-frontend-dist)
    to public/
  * To update the submodule after building a new distribution of the voting-frontend, run
    * `cd public && git pull origin master`

Set up local version of the [voting-frontend](https://github.com/hyy-vaalit/voting-frontend)
which will be run in a _different port_ than the Rails server.
Note that there are two different Frontend repositories:
`hyy-voting-frontend` (source code) and `hyy-voting-frontend-dist` (the compiled distribution).

Install Gem dependencies:
  * `gem install bundler` (needs only be done once)
  * `bundle install`

Configure `.env`
  * `cp .env.example .env`

Copy example certificates for use with Haka-test:
  * `cp -r doc/examples/haka-test cert`
  * These can be used with the federated Haka-test environment for authentication.
  * Haka-test examples are registered in the federated Haka-test environment for localhost usage.
    Haka-test will redirect to https://localhost.eneny.fi:3001 after a successful login.
  * Open `local-ssl-proxy --source 3001 --target 3999` to redirect SSL connection from Haka-test
    to the development web server which is running without SSL.

Quick setup for dev database:
  * `rake db:runts`

a) Insert demo seed data from HYY 2009 Elections
  * `rake db:seed:edari:demo`

b) Insert seed data in which you have exported from Ehdokastietojärjestelmä
  * `rake db:seed:edari`

c) Create a blank Election for testing
  * `rake db:seed:edari:election`

Manual setup for dev database:
```bash
rake db:create
rake db:schema:load

# List available seed tasks
rake -T db:seed
```

## Start services on the local machine

Start web server:
* `rails s`

## Sign in

### Example user without Haka-test

* Generate a sign-in link
  * rake jwt:voter:generate voter_id=1 expiry_hours=1000
  * voter_id:1 == testi.pekkanen@example.com
  * See `rails c` and `Voter.all`

## Example user from Haka-test

* Create a Voter for Teppo Testaaja with student number "x8734"

* Open an SSL tunnel in order to sign in with a Haka test account:
  * `npm install -g local-ssl-proxy`
  * `local-ssl-proxy --source 3001 --target 3000`
  * Target PORT is either 3000 in development (`.env`) or 3999 in test (`.env.test`)

* Open https://localhost.enemy.fi:3001

* Haka test user "teppo", password "testaaja"
  * Browser will display an SSL certificate error for "localhost", just skip it.
  * Haka certificate may have changed (expired) if signing in fails because of
    a SAML error, for example with
    `Invalid SAML response: ["Invalid Signature on SAML Response"]`
  * Check further instructions under
    [Haka knowledge base](https://github.com/hyy-vaalit/dokumentaatio/blob/master/haka/knowledge-base.md#csc-hakan-testipalvelu)


You may now open http://localhost.enemy.fi:3001 and sign in as Haka test user teppo/testaaja.

Start worker defined in `Procfile`:
`foreman run worker`


## Logs

Web server logs
  * `tail -f log/development.log`


## Email messages

A mock version of any sent email is automatically displayed when the worker is running:
  * `foreman run worker`


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


## Configure your Editor:

* Install Rubocop linter plugin which will lint Ruby on the fly,
  * Atom: `linter-rubocop`
  * https://buildtoship.com/integrate-rubocop-in-your-workflow/
  * Define exceptions in `.rubocop.yml`
  * Generate a TODO list of pending lints:
    `rubocop --auto-gen-config`

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


### Sending Email via Amazon SES

* Start creating an Amazon SES configuration by verifying your domain in AWS SES.
The verification process will take up 24-72 hours. Follow the instructions in AWS Console.

* Create an AWS IAM user with eg. full AWS SES privileges. Create an API key for this IAM user.

* Configure the environment variables prefixed with "AWS_SES".

* Notice that each AWS SES configuration is region based, so you'll need to verify your email
domain in each region separately. Region is selected by AWS_SES_REGION environment variable.

* ActionMailer is configured to use AWS SES in config/production.rb:
  `config.action_mailer.delivery_method = :aws_sdk`

* See also config/initializers/aws_ses.rb

## Tips

* A great app for exploring the development Postgresql database is
  [Postico](https://eggerapps.at/postico/).

* Reset your voting right to vote multiple times:
  - `VotingRight.find(X).update! used: false`

* SessionLink#deliver() will send email during HTTP request.
  This could be made to happen in the background.

* Sending a sign in link manually from console:
  - voter = Voter.find_by(email: 'teppo@example.com')
  - SessionLink.new(email: voter.email).deliver

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
  - FIXME Rails 7 changed how transactions work and `heroku run rake db:seed:edari` will rollback
    changes. For now, run each seed task manally

```bash
  rake db:seed:common
  rake db:seed:edari:election
  rake db:seed:edari:coalitions
  rake db:seed:edari:alliances
  rake db:seed:edari:candidates
  rake db:seed:edari:blank_candidate
  # NOTE: "heroku run --no-tty"
  rake db:seed:edari:voters_and_voting_rights:csv < voters.csv
```

  - Seed voters:
    - 1) Convert importable voter data into UTF-8. Isolatin data cannot be passed over
         `heroku` command.
    - 2a) text: `heroku run --no-tty rake db:seed:edari:voters_and_voting_rights < voters.txt`
    - 2b) csv: `heroku run --no-tty rake db:seed:edari:voters_and_voting_rights:csv < voters.csv`
  - Example seeds are available in the admin dashboard of Ehdokastietojärjestelmä

  * Production seed data is loaded to Heroku
    - a) from interactive terminal (copy-paste data and press ^D):
      * `heroku run rake db:seed:edari:candidates`

    - b) with `--no-tty` and `< filename`
      * `heroku run --no-tty rake db:seed:edari:candidates < candidates.csv`.

* B) Seed demo data without votes:
  - `heroku run rake db:seed:edari:demo`

* Generate a login token:
  - `heroku run rake jwt:voter:generate expiry_hours=1000 voter_id=1`

* Access console:
  `heroku console`

* Access logs:
  `heroku logs --tail`


## Importing Voters

- Obtain a copy of voters from the University.
- Convert file to UTF8 (Open in Sublime > Save in Encoding > UTF8).
- File is expected to be either in CSV (`ImportedCsvVoter`) or text format (`ImportedTextVoter`).
- See also "Testing in Heroku", notice the requirement about `heroku run --no-tty`
