class CreateImmutableVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :immutable_votes do |t|
      t.references :candidate, null: false
      t.references :election,  null: false

      t.timestamps
    end
  end
end
