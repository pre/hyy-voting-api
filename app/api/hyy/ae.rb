module HYY

  # Administration Election aka. hallintovaalit
  class AE < Grape::API

    before do
      @current_user = get_current_user headers

      error!({ message: 'Unauthorized' }, :unauthorized) unless @current_user

      begin
        authorize! :access, :ae_namespace
      rescue CanCan::AccessDenied => exception
        error!({ message: "Unauthorized: #{exception.message}" }, :unauthorized)
      end

    end

    mount HYY::AE::Ping
    mount HYY::AE::Elections
    mount HYY::AE::Votes
  end
end
