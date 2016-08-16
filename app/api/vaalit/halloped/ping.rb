module Vaalit
  module Halloped

    class Ping < Grape::API
      desc 'Returns authorized pong.'
      get :ping do
        {
          ping: params[:pong] || 'pong',
          current_user: @current_user.as_json
        }
      end
    end

  end
end
