require 'json'

class VoteStatistics

  # Use ">>" to pretty print json in console
  def self.by_hour_as_json
    stats = []
    total = {}

    by_hour.each do |data|
      row = {}

      key = "#{data.year.to_i}-#{data.month.to_i}-#{data.day.to_i} #{data.hour.to_i}:59"
      row[key] = data.vote_count.to_i

      stats << row
    end

    total[:vote_count] = ImmutableVote.count
    total[:percentage] = (100.0 * ImmutableVote.count / Voter.count).round(2)
    total[:voter_count] = Voter.count

    view_context.render(
      template: "vote_statistics/votes_by_hour.json.jbuilder",
      locals: { stats: stats, total: total }
    )
  end

  # All votes of every election grouped by hour.
  # ActiveRecord stores `datetime` attributes in the database without timezone,
  # although it stores all the values as UTC.
  # => created_at   | timestamp without time zone
  # As a workaround, the timezone is first cast as UTC and then to localtime.
  # Otherwise the hour is wrong by the amount of offset (+0200 or +0300).
  def self.by_hour
    ImmutableVote
      .select("
        date_part('hour', created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Helsinki') AS hour,
        date_part('day', created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Helsinki') AS day,
        date_part('month', created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Helsinki') AS month,
        date_part('year', created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Helsinki') AS year,
        COUNT(*) as vote_count
      ").group(
        "hour, day, month, year"
      ).order(
        "year, month, day, hour ASC"
      )
  end

  private_class_method def self.view_context
    ActionView::Base.new(ActionController::Base.view_paths)
  end

end
