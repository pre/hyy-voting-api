namespace :db do

  namespace :seed do
    namespace :common do

      def create_department_from_ko(koulutusohjelmat)
        koulutusohjelmat.each do |name, code|
          puts "Department: #{code} - #{name}"
          dep = Department.new(code: code, name: name)
          if dep.save
            # ok
          else
            Rails.logger.warn("Failed to create department #{dep.code} - #{dep.errors.full_messages}")
          end
          # faculty: Faculty.find_by_code!(faculty_code) # pitää tehä myöhemmin kun ei oo tätä tietoa nyt
        end
      end

      desc 'faculties'
      task :faculties => :environment do
        puts 'Seeding faculties ...'
        # Faculty.create! code: "1", name: 'Tuntematon'

        Faculty.create! code: "H10", name: 'Teologinen'
        Faculty.create! code: "H20", name: 'Oikeustieteellinen'
        Faculty.create! code: "H30", name: 'Lääketieteellinen'
        Faculty.create! code: "H40", name: 'Humanistinen'
        Faculty.create! code: "H50", name: 'Matemaattis-luonnontieteellinen'
        Faculty.create! code: "H55", name: 'Farmasia'
        Faculty.create! code: "H57", name: 'Bio- ja ympäristötieteellinen'
        Faculty.create! code: "H60", name: 'Kasvatustieteellinen'
        Faculty.create! code: "H70", name: 'Valtiotieteellinen'
        Faculty.create! code: "H80", name: 'Maatalous-metsätieteellinen'
        Faculty.create! code: "H90", name: 'Eläinlääketieteellinen'

        Faculty.create! code: "H74", name: 'Svenska social- och kommunalhögskolan'
      end

      desc 'departments'
      task :departments => :environment do
        puts "Seeding departments ..."

        koulutusohjelmat = {
          "Teologian ja uskonnontutkimuksen kandiohjelma" => "KH10_001",
          "Oikeusnotaarin koulutusohjelma" => "KH20_001",
          "Psykologian kandiohjelma" => "KH30_001",
          "Logopedian kandiohjelma" => "KH30_002",
          "Filosofian kandiohjelma" => "KH40_001",
          "Taiteiden tutkimuksen kandiohjelma" => "KH40_002",
          "Kielten kandiohjelma" => "KH40_003",
          "Kotimaisten kielten ja kirjallisuuksien kandiohjelma" => "KH40_004",
          "Kulttuurien tutkimuksen kandiohjelma" => "KH40_005",
          "Historian kandiohjelma" => "KH40_006",
          "Matemaattisten tieteiden kandiohjelma" => "KH50_001",
          "Fysikaalisten tieteiden kandiohjelma" => "KH50_002",
          "Matematiikan 004" => "KH50_004",
          "Tietojenkäsittelytieteen kandiohjelma" => "KH50_005",
          "Geotieteiden kandiohjelma" => "KH50_006",
          "Maantieteen kandiohjelma" => "KH50_007",
          "Bachelor's Programme in Science" => "KH50_008",
          "Farmaseutin koulutusohjelma" => "KH55_001",
          "Biologian kandiohjelma" => "KH57_001",
          "Molekyylibiotieteiden kandiohjelma" => "KH57_002",
          "Ympäristötieteiden kandiohjelma" => "KH57_003",
          "Kasvatustieteiden kandiohjelma" => "KH60_001",
          "Politiikan ja viestinnän kandiohjelma" => "KH70_001",
          "Yhteiskunnallisen muutoksen kandiohjelma" => "KH70_002",
          "Sosiaalitieteiden kandiohjelma" => "KH70_003",
          "Taloustieteen kandiohjelma" => "KH70_004",
          "Yhteiskuntatieteiden kandiohjelma" => "KH74_001",
          "Maataloustieteiden kandiohjelma" => "KH80_001",
          "Metsätieteiden kandiohjelma" => "KH80_002",
          "Elintarviketieteiden kandiohjelma" => "KH80_003",
          "Ympäristö- ja elintarviketalouden kandiohjelma" => "KH80_004",
          "Eläinlääketieteen kandiohjelma" => "KH90_001",
          "Teologian ja uskonnontutkimuksen maisteriohjelma" => "MH10_001",
          "Oikeustieteen maisterin koulutusohjelma" => "MH20_001",
          "Kansainvälisen liikejuridiikan maisteriohjelma (International Business Law)" => "MH20_002",
          "Globaalia hallintoa koskevan oikeuden maisteriohjelma" => "MH20_003",
          "Lääketieteen koulutusohjelma" => "MH30_001",
          "Translationaalisen lääketieteen maisteriohjelma (Translational Medicine)" => "MH30_002",
          "Hammaslääketieteen koulutusohjelma" => "MH30_003",
          "Psykologian maisteriohjelma" => "MH30_004",
          "Logopedian maisteriohjelma" => "MH30_005",
          "Taiteiden tutkimuksen maisteriohjelma" => "MH40_001",
          "Kielten maisteriohjelma" => "MH40_002",
          "Master's Programme in Russian Studies" => "MH40_004",
          "Kielellisen diversiteetin ja digitaalisten ihmistieteiden maisteriohjelma" => "MH40_005",
          "Kääntämisen ja tulkkauksen maisteriohjelma" => "MH40_006",
          "Suomen kielen ja suomalais-ugrilaisten kielten ja kulttuurien maisteriohjelma" => "MH40_007",
          "Pohjoismaisten kielten ja kirjallisuuksien maisteriohjelma" => "MH40_008",
          "Kirjallisuudentutkimuksen maisteriohjelma" => "MH40_009",
          "Kulttuuriperinnön maisteriohjelma" => "MH40_010",
          "Kulttuurienvälisen vuorovaikutuksen maisteriohjelma" => "MH40_011",
          "Alue- ja kulttuurintutkimuksen maisteriohjelma" => "MH40_012",
          "Sukupuolentutkimuksen maisteriohjelma" => "MH40_014",
          "Historian maisteriohjelma" => "MH40_015",
          "Matematiikan ja tilastotieteen maisteriohjelma" => "MH50_001",
          "Life Science Informatics -maisteriohjelma" => "MH50_002",
          "Teoreettisten ja laskennallisten menetelmien maisteriohjelma (Theoretical and Computational Methods)" => "MH50_003",
          "Alkeishiukkasfysiikan ja astrofysikaalisten tieteiden maisteriohjelma (Particle Physics and Astrophysical Sciences)" => "MH50_004",
          "Ilmakehätieteiden maisteriohjelma (Atmospheric Sciences)" => "MH50_006",
          "Matematiikan 008" => "MH50_008",
          "Tietojenkäsittelytieteen maisteriohjelma" => "MH50_009",
          "Datatieteen maisteriohjelma" => "MH50_010",
          "Geologian ja geofysiikan maisteriohjelma" => "MH50_011",
          "Maantieteen maisteriohjelma" => "MH50_012",
          "Kaupunkitutkimuksen ja suunnittelun maisteriohjelma" => "MH50_013",
          "Nordic Master Programme in Environmental Changes at Higher Latitudes" => "MH50_014",
          "Proviisorin koulutusohjelma" => "MH55_001",
          "Master's programme in Pharmaceutical Research" => "MH55_002",
          "Ekologian ja evoluutiobiologian maisteriohjelma" => "MH57_001",
          "Kasvitieteen maisteriohjelma" => "MH57_002",
          "Genetiikan ja molekulaaristen biotieteiden maisteriohjelma" => "MH57_003",
          "Neurotieteen maisteriohjelma" => "MH57_004",
          "Ympäristömuutoksen ja globaalin kestävyyden maisteriohjelma" => "MH57_005",
          "Kasvatustieteiden maisteriohjelma" => "MH60_001",
          "Muuttuvan kasvatuksen ja koulutuksen maisteriohjelma" => "MH60_002",
          "Filosofian maisteriohjelma" => "MH70_001",
          "Politiikan ja viestinnän maisteriohjelma" => "MH70_002",
          "Globaalin politiikan ja viestinnän maisteriohjelma" => "MH70_003",
          "Yhteiskunnallisen muutoksen maisteriohjelma" => "MH70_004",
          "Nyky-yhteiskunnan tutkimuksen maisteriohjelma" => "MH70_005",
          "Euroopan ja pohjoismaiden tutkimuksen maisteriohjelma (European and Nordic Studies)" => "MH70_006",
          "Sosiaalitieteiden maisteriohjelma" => "MH70_008",
          "Sosiaalitieteiden maisteriohjelma 2" => "MH70_008_2",
          "Taloustieteen maisteriohjelma" => "MH70_009",
          "International Masters in Economy" => "MH70_010",
          "Sosiaali- ja terveystutkimuksen ja -johtamisen maisteriohjelma" => "MH70_011",
          "Maataloustieteiden maisteriohjelma" => "MH80_001",
          "Maatalous-" => "MH80_002",
          "Metsätieteiden maisteriohjelma" => "MH80_003",
          "Elintarviketieteiden maisteriohjelma" => "MH80_004",
          "Ihmisen ravitsemuksen ja ruokakäyttäytymisen maisteriohjelma" => "MH80_005",
          "Elintarviketalouden ja kulutuksen maisteriohjelma" => "MH80_006",
          "Mikrobiologian ja mikrobibiotekniikan maisteriohjelma" => "MH80_007",
          "Eläinlääketieteen lisensiaatin koulutusohjelma" => "MH90_001",
          "Teologian ja uskonnontutkimuksen tohtoriohjelma" => "T920101",
          "Oikeustieteen tohtoriohjelma" => "T920102",
          "Historian ja kulttuuriperinnön tohtoriohjelma" => "T920103",
          "Kielentutkimuksen tohtoriohjelma" => "T920104",
          "Sukupuolen" => "T920105",
          "Sosiaalitieteiden tohtoriohjelma" => "T920106",
          "Poliittisten" => "T920107",
          "Koulun" => "T920109",
          "Kognition" => "T920110",
          "Filosofian" => "T920111",
          "Biolääketieteellinen tohtoriohjelma" => "T921101",
          "Kliininen tohtoriohjelma" => "T921102",
          "Väestön terveyden tohtoriohjelma" => "T921103",
          "Suun terveystieteen tohtoriohjelma" => "T921104",
          "Lääketutkimuksen tohtoriohjelma" => "T921105",
          "Integroivien biotieteiden tohtoriohjelma" => "T921106",
          "Aivot ja mieli tohtoriohjelma" => "T921107",
          "Kliinisen eläinlääketieteen tohtoriohjelma" => "T921108",
          "Ihmisen käyttäytymisen tohtoriohjelma" => "T921109",
          "Luonnonvaraisten eliöiden tutkimuksen tohtoriohjelma (LUOVA)" => "T922101",
          "Kasvitieteen tohtoriohjelma (DPPS)" => "T922102",
          "Ympäristöalan tieteidenvälinen tohtoriohjelma (DENVI)" => "T922103",
          "Uusiutuvien luonnonvarojen kestävän käytön tohtoriohjelma (AGFOREE)" => "T922104",
          "Mikrobiologian ja biotekniikan tohtoriohjelma" => "T922105",
          "Ruokaketjun ja terveyden tohtoriohjelma" => "T922106",
          "Alkeishiukkasfysiikan ja maailmankaikkeuden tutkimuksen tohtoriohjelma (PAPU)" => "T923101",
          "Geotieteiden tohtoriohjelma" => "T923102",
          "Geotieteiden tohtoriohjelma (GeoDoc)" => "T923102",
          "Ilmakehätieteiden tohtoriohjelma (ATM-DP)" => "T923103",
          "Kemian ja molekyylitieteiden tohtoriohjelma (CHEMS)" => "T923104",
          "Matematiikan ja tilastotieteen tohtoriohjelma" => "T923105",
          "Matematiikan ja tilastotieteen tohtoriohjelma (Domast)" => "T923105",
          "Materiaalitutkimuksen ja nanotieteiden tohtoriohjelma (MATRENA)" => "T923106",
          "Tietojenkäsittelytieteen tohtoriohjelma" => "T923107",
          "Tietojenkäsittelytieteen tohtoriohjelma (DoCS)" => "T923107"
        }

        create_department_from_ko(koulutusohjelmat)
      end
    end

    desc 'common data (faculties, departments)'
    task :common => :environment do
      Rake::Task['db:seed:common:faculties'].invoke()
      Rake::Task['db:seed:common:departments'].invoke()
    end
  end
end
