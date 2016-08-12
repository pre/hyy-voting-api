class CreateCoalitions < ActiveRecord::Migration[5.0]
  def change
    create_table :coalitions do |t|
      t.string :name
      t.string :short_name
      t.integer :numbering_order

      t.references :election, null: false
      t.timestamps
    end
  end
end
