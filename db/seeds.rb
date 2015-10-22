# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


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
