module HYY
  class AE < Grape::API

    before do
      # TODO: Extract class and handle expired token
      @current_user = Voter.find decode_jwt(headers)["voter_id"]

      error!('Unauthorized', 401) unless @current_user
    end

    mount HYY::AE::Ping
    mount HYY::AE::Votes

  end
end
