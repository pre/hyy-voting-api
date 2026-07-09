class AddUniqueIndexesToVoters < ActiveRecord::Migration[7.2]
  # Enforce voter uniqueness at the database level. Haka sign-in resolves the
  # voter by student_number, and email lookups are case-insensitive
  # (Voter.find_by_email uses lower(email)), so the functional index both
  # enforces uniqueness and makes the lookup indexable.
  #
  # NULLs stay allowed: Postgres treats NULLs as distinct in unique indexes,
  # matching the model's allow_nil validations.
  #
  # This migration intentionally fails loudly if the database already
  # contains duplicates: duplicates are cleaned up manually, and the database
  # is recreated between elections.
  #
  # Note: ssn is deliberately NOT unique. Its uniqueness was removed in 2022
  # (20221025075954_remove_uniquenes_on_voter_ssn.rb) because some students
  # may have a placeholder ssn like "000000-0000". Voting right is verified
  # by student_number.
  def change
    add_index :voters, :student_number, unique: true

    remove_index :voters, name: "index_voters_on_email"
    add_index :voters, "lower(email)", unique: true, name: "index_voters_on_lower_email"
  end
end
