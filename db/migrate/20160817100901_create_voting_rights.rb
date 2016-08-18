class CreateVotingRights < ActiveRecord::Migration[5.0]
  def change
    create_table :voting_rights do |t|
      t.references :election, null: false
      t.references :voter, null: false
      t.boolean :used, null: false, default: false

      t.timestamps
    end

    add_index :voting_rights, [:voter_id, :election_id], unique: true
    add_foreign_key :voting_rights, :elections
    add_foreign_key :voting_rights, :voters
  end
end
