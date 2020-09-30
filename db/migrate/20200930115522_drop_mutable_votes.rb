class DropMutableVotes < ActiveRecord::Migration[5.2]
  def change
    drop_table :mutable_votes
  end
end
