module Vaalit
  module Voters
    class VotersApi < Grape::API

      before do
        @current_user = current_service_user headers

        error!({ message: 'Unauthorized' }, :unauthorized) unless @current_user

        begin
          authorize! :access, :voters
        rescue CanCan::AccessDenied => exception
          error!({ message: "Unauthorized: #{exception.message}" }, :unauthorized)
        end

      end

      namespace :sessions do
        params do
          requires :email, type: String, desc: 'Email where the sign-in link will be sent'
        end
        desc 'Send a sign-in link for the voter.'
        post :link do
          session_link = SessionLink.new email: params[:email]

          if session_link.valid? && session_link.deliver
            { response: "Link has been sent" }
          else
            error!(
              {
                message: "Could not generate sign-in link: #{session_link.errors[:email].first}",
                key: session_link.errors[:email_error_key].first
              }, :unprocessable_entity
            )
          end
        end
      end

      namespace :elections do
        params do
          requires :election_id, type: Integer
        end

        route_param :election_id do
          before do
            @election = Election.find params[:election_id]
          end

          namespace :voters do
            params do
              requires :voter, type: Hash do
                requires :ssn, type: String
                requires :student_number, type: String
                requires :name, type: String
                requires :email, type: String
                optional :phone, type: String
                optional :faculty_code, type: String
                optional :department_code, type: String
              end
            end
            desc 'Create a new voter with a voting right in current election' do
              failure [[422, 'Unprocessable entity', Errors::Voter]]
            end
            post do
              voter = Voter.build_from params['voter']

              if voter.save && voter.create_voting_right(election: @election)
                present voter, using: Entities::Voter
              else
                error!(
                  {
                    errors: voter.errors,
                    message: 'Voter could not be created'
                  },
                  422
                )
              end
            end

            desc 'List voters created after elections have started'
            get do
              present Voter.created_during_elections,
                      using: Entities::Voter
            end
          end
        end
      end
    end
  end
end
