namespace :db do

  namespace :seed do

    desc 'Seed data for faculties'
    task :faculties => :environment do
      puts 'Seeding faculties ...'
      Faculty.create! :abbr => 'B', :code => "H57", :name => 'Biotieteellinen'
      Faculty.create! :abbr => 'E', :code => "H90", :name => 'Eläinlääketieteellinen'
      Faculty.create! :abbr => 'F', :code => "H55", :name => 'Farmasia'
      Faculty.create! :abbr => 'H', :code => "H40", :name => 'Humanistinen'
      Faculty.create! :abbr => 'K', :code => "H60", :name => 'Käyttäytymistieteellinen'
      Faculty.create! :abbr => 'L', :code => "H30", :name => 'Lääketieteellinen'
      Faculty.create! :abbr => 'ML',:code => "H50", :name => 'Matemaattis-luonnontieteellinen'
      Faculty.create! :abbr => 'MM',:code => "H80", :name => 'Maa- ja metsätieteellinen'
      Faculty.create! :abbr => 'O', :code => "H20", :name => 'Oikeustieteellinen'
      Faculty.create! :abbr => 'T', :code => "H10", :name => 'Teologinen'
      Faculty.create! :abbr => 'V', :code => "H70", :name => 'Valtiotieteellinen'
      Faculty.create! :abbr => 'S', :code => "H74", :name => 'Svenska social- och kommunalhögskolan'

      Faculty.create! :abbr => 'XYZ', :code => "930", :name => 'Unknown faculty'
      Faculty.create! :abbr => 'XXX', :code => "Y01", :name => 'Unknown faculty 2'
    end

  end
end
