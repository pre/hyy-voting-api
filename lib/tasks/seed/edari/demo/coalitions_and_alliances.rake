
namespace :db do
  namespace :seed do
    namespace :edari do
      namespace :demo do

        def create_alliance!(coalition, opts)
          alliance = coalition.alliances.build(opts)
          alliance.election = Election.first # no significance in Edari elections
          alliance.save!

          alliance
        end

        def create_coalition!(name:, short_name:, numbering_order:)
          coalition = Coalition.new.tap do |c|
            c.name = name
            c.short_name = short_name
            c.numbering_order = numbering_order
            c.election = Election.first # no significance in Edari elections
          end

          coalition.save!

          coalition
        end

        desc 'demo coalitions and alliances'
        task :coalitions_and_alliances => :environment do
          Rails.logger.info "Seeding DEMO coalitions ..."

          # Coalitions with multiple alliances
          hyal   = create_coalition! name: 'Ainejärjestöjen vaalirengas',                 short_name: 'HYAL',   :numbering_order => "10"
          osak   = create_coalition! name: 'Osakuntien suuri vaalirengas',                short_name: 'Osak',   :numbering_order => "9"
          mp     = create_coalition! name: 'Maailmanpyörä',                               short_name: 'MP',     :numbering_order => "8"
          help   = create_coalition! name: 'HELP',                                        short_name: 'HELP',   :numbering_order => "6"
          pelast = create_coalition! name: 'Pelastusrengas',                              short_name: 'Pelast', :numbering_order => "4"
          snaf   = create_coalition! name: 'Svenska Nationer och Ämnesföreningar (SNÄf)', short_name: 'SNÄf',   :numbering_order => "5"

          # Coalitions with a single alliance
          demarit  = create_coalition! name: 'Opiskelijademarit',                                   short_name: 'OSY',    :numbering_order => "3"
          tsemppi  = create_coalition! name: 'Tsemppi Group',                                       short_name: 'Tsempp', :numbering_order => "2"
          piraatit = create_coalition! name: 'Akateemiset piraatit',                                short_name: 'Pirate', :numbering_order => "1"
          persut   = create_coalition! name: 'Perussuomalainen vaaliliitto',                        short_name: 'Peruss', :numbering_order => "7"
          libera   = create_coalition! name: 'Liberaalinen vaaliliitto - Yksilönvapauden puolesta', short_name: 'Libera', :numbering_order => "5"
          ite1     = create_coalition! name: 'Itsenäinen ehdokas 1',                                short_name: 'ITE1',   :numbering_order => "11"

          Rails.logger.info "Seeding DEMO alliances ..."

          create_alliance! mp, name: 'HYYn Vihreät - De Gröna vid HUS',  short_name: 'HyVi'
          create_alliance! mp, name: 'Sitoutumaton vasemmisto - Obunden vänster - Independent left', short_name: 'SitVas'
          create_alliance! hyal, name: 'Humanistit',                     short_name: 'Humani'
          create_alliance! hyal, name: 'Viikki',                         short_name: 'Viikki'
          create_alliance! help, name: 'Pykälä',                         short_name: 'Pykälä'
          create_alliance! hyal, name: 'Kumpula',                        short_name: 'Kumpul'
          create_alliance! help, name: 'LKS / HLKS',                     short_name: 'LKSHLK'
          create_alliance! hyal, name: 'Käyttis',                        short_name: 'Käytti'
          create_alliance! osak, name: 'ESO',                            short_name: 'ESO'
          create_alliance! pelast, name: 'Kokoomusopiskelijat 1',        short_name: 'Kok1'
          create_alliance! help, name: 'EKY',                            short_name: 'EKY'
          create_alliance! hyal, name: 'Valtiotieteilijät',              short_name: 'Valtio'
          create_alliance! hyal, name: 'Teologit',                       short_name: 'Teolog'
          create_alliance! osak, name: 'HO-Natura',                      short_name: 'HO-Nat'
          create_alliance! osak, name: 'EPO',                            short_name: 'EPO'
          create_alliance! pelast, name: 'Kokoomusopiskelijat 2',        short_name: 'Kok2'
          create_alliance! osak, name: 'Domus Gaudiumin osakunnat',      short_name: 'DG'
          create_alliance! osak, name: 'PPO',                            short_name: 'PPO'
          create_alliance! pelast, name: 'Keskeiset',                    short_name: 'Kesk'
          create_alliance! osak, name: 'SavO',                           short_name: 'SavO'
          create_alliance! osak, name: 'KSO-VSO',                        short_name: 'KSOVSO'
          create_alliance! demarit, name: 'Opiskelijademarit',           short_name: 'OSY'
          create_alliance! snaf, name: 'StudOrg',                        short_name: 'StudO'
          create_alliance! osak, name: 'SatO-ESO2',                      short_name: 'SatESO'
          create_alliance! snaf, name: 'Nationerna',                     short_name: 'Nation'
          create_alliance! tsemppi, name: 'Tsemppi Group',               short_name: 'Tsempp'
          create_alliance! snaf, name: 'Codex-Thorax',                   short_name: 'CodTho'
          create_alliance! pelast, name: 'KD Helsingin opiskelijat',     short_name: 'KD'
          create_alliance! piraatit, name: 'Akateemiset piraatit',       short_name: 'Pirate'
          create_alliance! persut, name: 'Perussuomalainen vaaliliitto', short_name: 'Peruss'
          create_alliance! snaf, name: 'Ämnesföreningarna',              short_name: 'Ämnesf'
          create_alliance! ite1, name: 'Itsenäinen ehdokas 1',           short_name: 'ITE1'
          create_alliance! libera, name: 'Liberaalinen vaaliliitto - yksilönvapauden puolesta', short_name: 'Libera'
        end

      end
    end
  end
end
