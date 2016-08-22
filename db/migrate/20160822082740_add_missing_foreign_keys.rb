class AddMissingForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :alliances, :coalitions
    add_foreign_key :immutable_votes, :candidates
    add_foreign_key :immutable_votes, :elections
  end
end
