module HYY
  module AE
    class Protected < Grape::API
      namespace :protected do
        http_basic do |username, password|
          username == 'user' && password == 'pass'
        end
        desc 'Returns pong if username=username and password=password.'
        get :ping do
          { ping: 'pong' }
        end
      end
    end
  end
end
