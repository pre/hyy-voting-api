module HYY
  class AE < Grape::API

    before do
      @current_user = decode_jwt(headers)

      error!("Unauthorized", 401) unless @current_user
    end

    mount HYY::AE::Ping

  end
end
