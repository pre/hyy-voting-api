class VoterStatistics

  # List vote counts by department
  #
  # Check also:
  #   Voter.where("department_id is null")
  #   Voter.where("faculty_id is null")
  def self.by_department(include_voted_only:)
    query = Voter.select("
      departments.name AS DEPARTMENT_NAME, COUNT(*) as VOTER_COUNT
    ").joins("
      INNER JOIN voting_rights ON voting_rights.voter_id = voters.id
    ").joins("
      INNER JOIN departments ON departments.id = voters.department_id
    ")

    if include_voted_only
      query = query.where("voting_rights.used = TRUE")
    end

    query.group("departments.name")
  end

end
