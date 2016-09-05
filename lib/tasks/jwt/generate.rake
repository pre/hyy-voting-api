namespace :jwt do

  def generate(payload, secret, expiry_number)
    payload ||= { name: "i'm a service user" }
    expiry_number ||= "24"

    expiry_time = expiry_number.to_i.hours.from_now

    puts "Time.now: #{Time.now}"
    puts "Expiry: #{expiry_time} (expires in #{expires_in(expiry_time)} hours)"
    puts "Payload: #{payload}"

    token = JsonWebToken.encode payload, secret, expiry_time
    puts ""
    puts "HTTP Header:"
    puts "Authorization: Bearer #{token}"
    puts ""
    puts "Link:"
    puts "#{Vaalit::Public::SITE_ADDRESS}/#/sign-in?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2b3Rlcl9pZCI6MSwiZXhwIjoxNDc2NjgxNjg2fQ.3VhewMgTpk7fErZlMgoPasI1Dos_B5R15-0uIXv5SgE"
  end

  def expires_in(expiry)
    ((expiry - Time.now) / 1.hours).round
  end

  def verify(jwt, secret)
    decoded = JsonWebToken.decode jwt, secret
    if decoded.nil?
      puts "Token could not be decoded"
      return
    end

    payload = decoded.first
    expiry_time = Time.at payload['exp']

    puts "Full content:"
    puts decoded.to_s
    puts ""
    puts "Expiry: #{expiry_time} (expires in #{expires_in(expiry_time)} hours)"
    puts "Payload: #{payload}"
  end

  namespace :service_user do
    desc 'generate a JWT token for API access'
    task :generate, [:payload, :expiry_hours] => :environment do
      generate ENV['payload'],
               Rails.application.secrets.jwt_service_user_secret,
               ENV['expiry_hours']
    end

    desc 'verify a JWT token'
    task :verify, [:jwt] => :environment do
      verify ENV['jwt'], Rails.application.secrets.jwt_service_user_secret
    end
  end

  namespace :voter do
    desc 'generate a JWT token for Frontend access'
    task :generate, [:voter_id, :expiry_hours] => :environment do
      voter_id = ENV['voter_id'] || 1
      payload = { voter_id: voter_id.to_i }

      generate payload,
               Rails.application.secrets.jwt_voter_secret,
               ENV['expiry_hours']
    end

    desc 'verify a JWT token'
    task :verify, [:jwt] => :environment do
      verify ENV['jwt'], Rails.application.secrets.jwt_voter_secret
    end
  end
end
