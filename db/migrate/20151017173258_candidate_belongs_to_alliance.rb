class CandidateBelongsToAlliance < ActiveRecord::Migration
  def change
    add_column :candidates, :alliance_id, :integer, null: false

    add_foreign_key :candidates, :alliances
  end
end
