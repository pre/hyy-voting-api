module HYY
  class AE < Grape::API

    before do
      @current_user = get_current_user headers

      error!('Unauthorized', 401) unless @current_user
    end

    mount HYY::AE::Ping
    mount HYY::AE::Votes

  end
end
