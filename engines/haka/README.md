# Haka
Short description and motivation.

## Testing

* Install Firefox
* Install [Geckodriver](https://github.com/mozilla/geckodriver/releases)


## Tips

* All Gemfile dependencies must be explicitly required in `lib/haka/engine.rb`.

* Error with Capybara tests: "unable to obtain stable firefox connection in 60 seconds (127.0.0.1:7055)"
  * Update Selenium, Firefox or Geckodriver so that the combination of their versions works.
