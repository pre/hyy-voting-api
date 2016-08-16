module Vaalit
  module Edari

    class EdariApi < Grape::API

      before do
        @current_user = get_current_user headers

        error!({ message: 'Unauthorized' }, :unauthorized) unless @current_user

        begin
          authorize! :access, :elections
        rescue CanCan::AccessDenied => exception
          error!({ message: "Unauthorized: #{exception.message}" }, :unauthorized)
        end

      end

      mount Vaalit::Elections
    end

  end
end
