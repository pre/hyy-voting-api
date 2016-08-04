module Edari

  class Public < Grape::API
    desc 'Returns public plong.'
    get :pling do
      {
        pling: params[:pling] || 'plong',
      }
    end
  end

end
