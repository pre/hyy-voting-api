class ScopeVoteUniquenessByElection < ActiveRecord::Migration
  def change
    remove_index :votes, name: :index_votes_on_voter_id

    add_index :votes, [:voter_id, :election_id], unique: true
  end
end
