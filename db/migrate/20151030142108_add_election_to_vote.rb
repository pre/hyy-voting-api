class AddElectionToVote < ActiveRecord::Migration
  def change
    add_column :votes, :election_id, :integer, null: false

    add_foreign_key :votes, :elections
  end
end
