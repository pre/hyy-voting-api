module HYY

    class AE::Ping < Grape::API
      desc 'Returns pong.'
      get :ping do
        { ping: params[:pong] || 'pong' }
      end
    end

end
