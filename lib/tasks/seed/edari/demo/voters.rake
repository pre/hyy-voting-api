namespace :db do
  namespace :seed do
    namespace :edari do
      namespace :demo do

        desc 'demo voters'
        task :voters => :environment do
          Rails.logger.info "Seeding demo voters ..."

          Voter.create!(
            :name => "Testi Pekkanen",
            :email => "testi.pekkanen@example.com",
            :ssn => "123456789A",
            :student_number => "987654321",
            :start_year => "2001",
            :extent_of_studies => "4",
            :faculty => Faculty.first,
            :department => Department.first
          )

          Voter.create!(
            :name => "Kesti Rekkanen",
            :email => "kesti.rekkanen@example.com",
            :ssn => "112233123A",
            :student_number => "998877665",
            :start_year => "2005",
            :extent_of_studies => "3",
            :faculty => Faculty.last,
            :department => Department.last
          )

          # Haka test user
          Voter.create!(
            :name => "Teppo 'Haka User' Testaaja",
            :email => "teppo@nonexistent.tld",
            :student_number => "x8734",
            :faculty => Faculty.last,
            :department => Department.last,
            :ssn => "121212-1234"
          )
        end

      end
    end
  end
end
