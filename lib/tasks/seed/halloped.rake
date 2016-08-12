namespace :db do

  desc 'Seed data'
  namespace :seed do
    namespace :halloped do
      desc 'Halloped elections with alliances and candidates'
      task :elections => :environment do
        puts "Seeding example Halloped data ..."

        Election.create!(
          name: "Liittovaltiovaalit",
          faculty: Faculty.first
        )

        Election.create!(
          name: "Paremmat vaalit",
          faculty: Faculty.first
        )

        Election.create!(
          name: "Sivukampuksen tiedekuntavaalit",
          faculty: Faculty.first
        )

        Alliance.create!(
          name: "Kauppiaat",
          election: Election.first,
          faculty: Faculty.first,
          short_name: "kauppi",
          numbering_order: 1
        )

        Candidate.create!(
          alliance: Alliance.first,
          firstname: "Ikea",
          lastname: "Kassi",
          candidate_name: "Ikea Kassi (Vahva Kangas)",
          ssn: "123456789A",
          candidate_number: 2,
          numbering_order: 2
        )

        Candidate.create!(
          alliance: Alliance.first,
          firstname: "S-Market",
          lastname: "Etukortti",
          candidate_name: "S-Market Etukortti (Vihreä Muovi)",
          ssn: "123456710A",
          candidate_number: 3,
          numbering_order: 3
        )

        Candidate.create!(
          alliance: Alliance.first,
          firstname: "Kesko",
          lastname: "Plussa",
          candidate_name: "Kesko Plussa (Etu Seteli)",
          ssn: "123456711A",
          candidate_number: 4,
          numbering_order: 4
        )

        Alliance.create!(
          name: "Asiakkaat",
          short_name: "asiak",
          election: Election.first,
          faculty: Faculty.first,
          numbering_order: 2
        )

        Candidate.create!(
          alliance: Alliance.last,
          firstname: "Seppo",
          lastname: "Suomalainen",
          candidate_name: "Seppo Suomalainen (Sami Salaperäinen)",
          ssn: "223456789A",
          candidate_number: 5,
          numbering_order: 5
        )

        Candidate.create!(
          alliance: Alliance.last,
          firstname: "Marja",
          lastname: "Puuro",
          candidate_name: "Marja Puuro (Puolukka Rahka)",
          ssn: "323456789A",
          candidate_number: 6,
          numbering_order: 6
        )

        Candidate.create!(
          alliance: Alliance.last,
          firstname: "Smultron",
          lastname: "Robotten",
          candidate_name: "Smultron Robotten (Great Balance)",
          ssn: "423456789A",
          candidate_number: 7,
          numbering_order: 7
        )

      end
    end

  end
end
