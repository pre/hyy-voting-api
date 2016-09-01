namespace :db do
  namespace :seed do
    namespace :edari do

      desc 'allow blank vote with a special blank candidate (candidate_number 1)'
      task :blank_candidate => :environment do
        Rails.logger.info "Creating a blank candidate to allow protest votes"
        edari_election = Election.first

        # Make sure numbering_order has the lowest value of all
        blank_coalition = Coalition.create!(
          name: "Tyhjä ääni / Blankröst / Blank vote",
          numbering_order: -1,
          election: edari_election,
          short_name: 'TYHJÄ')

        blank_alliance = Alliance.create!(
          name: "Äänestän tyhjää",
          election: edari_election,
          coalition: blank_coalition,
          numbering_order: 0,
          short_name: 'TYHJÄ')

        Candidate.create!(
          alliance: blank_alliance,
          firstname: "Tyhjä",
          lastname: "Tyhjä",
          candidate_name: "Tyhjä ääni / Blankröst / Blank vote",
          candidate_number: Vaalit::Config::BLANK_CANDIDATE_NUMBER)
      end
    end
  end
end
