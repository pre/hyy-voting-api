module Vaalit

  class Pling < Grape::API
    desc 'Returns public plong.'
    get :pling do
      {
        pling: params[:pling] || 'plong',
      }
    end
  end

end
