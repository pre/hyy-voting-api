class CreateAlliances < ActiveRecord::Migration
  def change
    create_table :alliances do |t|
      t.string :name, null: false
      
      t.integer :election_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :alliances, :elections
  end
end
