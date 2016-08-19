class RenameVoteToMutableVote < ActiveRecord::Migration[5.0]
  def change
    rename_table :votes, :mutable_votes
  end
end
