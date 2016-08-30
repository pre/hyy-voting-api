module Vaalit
  module Export
    class Votes < Grape::API

      namespace :export do

        namespace :elections do
          params do
            requires :election_id, type: Integer
          end

          route_param :election_id do
            before do
              @election = Election.find params[:election_id]
            end

            namespace :votes do
              format :txt

              desc 'GET votes of current election'
              get do
                ImmutableVoteExport.new(@election).to_csv
              end
            end
          end
        end
      end
    end
  end
end
