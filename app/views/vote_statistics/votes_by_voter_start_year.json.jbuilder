json.name "Äänten lukumäärä aloitusvuoden mukaan"
json.year Time.now.year
json.created_at Time.now.localtime

json.children do
  json.start_years do
    json.array! stats do |row|
      json.start_year row["start_year"]
      json.voter_count row["voter_count"]
      json.vote_count row["vote_count"]
      json.percentage row["percentage"]
      json.combined row["combined"]
    end
  end

  json.total do
    json.vote_count total[:vote_count]
    json.voter_count total[:voter_count]
    json.percentage total[:percentage]
  end
end
