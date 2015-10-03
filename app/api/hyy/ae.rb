module HYY
  class AE < Grape::API

    before do
      error! "Wat" unless verify_jwt(headers)
    end

    mount HYY::AE::Ping

  end
end
