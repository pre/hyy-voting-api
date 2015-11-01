module HYY
  class AE < Grape::API

    before do
      @current_user = get_current_user headers

      error!('Unauthorized', :unauthorized) unless @current_user

      begin
        authorize! :access, :elections
      rescue CanCan::AccessDenied => exception
        error!("Unauthorized: #{exception.message}", :unauthorized)
      end

    end

    mount HYY::AE::Ping
    mount HYY::AE::Elections
    mount HYY::AE::Votes

  end
end
