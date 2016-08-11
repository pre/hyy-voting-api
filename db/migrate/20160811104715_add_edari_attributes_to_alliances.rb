class AddEdariAttributesToAlliances < ActiveRecord::Migration[5.0]
  def change
    change_table :alliances do |t|
      t.string :short_name, null: false

      t.references :coalition, null: false
    end
  end
end
