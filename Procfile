web: bundle exec puma -C config/puma.rb
worker: bundle exec rake jobs:work
# Sign in with Haka test using https://localhost.enemy.fi:3001 using "hyy.voting.test.local"
sslproxy: local-ssl-proxy --source 3001 --target 3000
