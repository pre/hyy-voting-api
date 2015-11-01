# coding: utf-8

namespace :db do

  desc 'Seed data'
  namespace :seed do

    def create_department(code, faculty_code, name)
      Department.create! code: code,
                         name: name,
                         faculty: Faculty.find_by_code(faculty_code)
    end

    desc 'for faculties'
    task :faculties => :environment do
      puts 'Seeding faculties ...'
      Faculty.create! code: "H10", name: 'Teologinen'
      Faculty.create! code: "H20", name: 'Oikeustieteellinen'
      Faculty.create! code: "H30", name: 'Lääketieteellinen'
      Faculty.create! code: "H40", name: 'Humanistinen'
      Faculty.create! code: "H50", name: 'Matemaattis-luonnontieteellinen'
      Faculty.create! code: "H55", name: 'Farmasia'
      Faculty.create! code: "H57", name: 'Bio- ja ympäristötieteellinen'
      Faculty.create! code: "H60", name: 'Käyttäytymistieteellinen'
      Faculty.create! code: "H70", name: 'Valtiotieteellinen'
      Faculty.create! code: "H80", name: 'Maatalous-metsätieteellinen'
      Faculty.create! code: "H90", name: 'Eläinlääketieteellinen'

      Faculty.create! code: "H74", name: 'Svenska social- och kommunalhögskolan'
      Faculty.create! code: "Y01", name: 'Viikin laaja-alaiset koulutukset'
    end

    desc 'for departments'
    task :departments => :environment do
      puts "Seeding departments ..."

      create_department "H345", "H30", "Medicum"
      create_department "H370", "H30", "Clinicum"

      create_department "H440", "H40", "Suomen kielen, suomalais-ugrilaisten ja pohjoismaisten kielten ja kirjallisuuksien laitos"
      create_department "H450", "H40", "Nykykielten laitos"
      create_department "H460", "H40", "Maailman kulttuurien laitos"
      create_department "H470", "H40", "Filosofian, historian, kulttuurin ja taiteiden tutkimuksen laitos"

      create_department "H510", "H50", "Geotieteiden ja maantieteen laitos"
      create_department "H516", "H50", "Matematiikan ja tilastotieteen laitos"
      create_department "H523", "H50", "Tietojenkäsittelytieteen laitos"
      create_department "H528", "H50", "Fysiikan laitos"
      create_department "H529", "H50", "Kemian laitos"

      create_department "H573", "H57", "Biotieteiden laitos"
      create_department "H575", "H57", "Ympäristötieteiden laitos"

      create_department "H620", "H60", "Opettajankoulutuslaitos"
      create_department "H630", "H60", "Käyttäytymistieteiden laitos"

      create_department "H720", "H70", "Sosiaalitieteiden laitos"
      create_department "H725", "H70", "Politiikan ja talouden tutkimuksen laitos"

      create_department "H820", "H80", "Metsätieteiden laitos"
      create_department "H830", "H80", "Maataloustieteiden laitos"
      create_department "H840", "H80", "Elintarvike- ja ympäristötieteiden laitos"
      create_department "H850", "H80", "Taloustieteen laitos"
    end

    desc 'all base data'
    task :base => :environment do
      Rake::Task['db:seed:faculties'].invoke()
      Rake::Task['db:seed:departments'].invoke()
    end
  end
end
