require 'rails_helper'

describe BasicAuthFence do
  let(:app) { ->(_env) { [200, {}, ['downstream']] } }
  let(:request) { Rack::MockRequest.new(described_class.new(app, 'user', 'secret')) }

  def basic_auth(username, password)
    "Basic #{Base64.strict_encode64("#{username}:#{password}")}"
  end

  it 'rejects requests without credentials' do
    response = request.get('/api/v1/elections')

    expect(response.status).to eq 401
  end

  it 'rejects requests with wrong Basic credentials' do
    response = request.get('/api/v1/elections',
                           'HTTP_AUTHORIZATION' => basic_auth('user', 'wrong'))

    expect(response.status).to eq 401
  end

  it 'passes requests with correct Basic credentials' do
    response = request.get('/api/v1/elections',
                           'HTTP_AUTHORIZATION' => basic_auth('user', 'secret'))

    expect(response.status).to eq 200
    expect(response.body).to eq 'downstream'
  end

  it 'passes requests with a Bearer header through to JWT auth' do
    response = request.get('/api/v1/elections',
                           'HTTP_AUTHORIZATION' => 'Bearer some.jwt.token')

    expect(response.status).to eq 200
    expect(response.body).to eq 'downstream'
  end
end
