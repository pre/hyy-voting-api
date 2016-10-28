json.name "Äänten lukumäärä tunneittain"
json.year Time.now.year
json.created_at Time.now.localtime

json.children do
  json.votes do
    cumulative_count = 0

    json.array! stats do |row|
      row.each do |time, hourly_count|
        cumulative_count += hourly_count

        json.time time
        json.hourly_count hourly_count
        json.cumulative_count cumulative_count
      end
    end
  end

  json.total do
    json.vote_count total[:vote_count]
    json.voter_count total[:voter_count]
    json.percentage total[:percentage]
  end

end
