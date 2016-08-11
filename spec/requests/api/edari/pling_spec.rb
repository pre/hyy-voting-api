require 'rails_helper'

describe Edari::Public do

  context 'get /api/pling' do
    it 'returns plong' do
      get '/api/pling'

      expect(response).to be_success
      expect(json["pling"]).to eq("plong")
    end

    it 'echos back something else' do
      get '/api/pling', params: { pling: "something else" }

      expect(response).to be_success
      expect(json["pling"]).to eq("something else")
    end
  end
end
