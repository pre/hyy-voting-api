require 'rails_helper'

describe Vaalit::Pling do

  context 'get /api/pling' do
    it 'returns plong' do
      get '/api/pling'

      expect(response).to be_successful
      expect(json["pling"]).to eq("plong")
    end

    it 'echos back something else' do
      get '/api/pling', params: { pling: "something else" }

      expect(response).to be_successful
      expect(json["pling"]).to eq("something else")
    end
  end
end
