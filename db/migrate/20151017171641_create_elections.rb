class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :name, null: false
      t.integer :faculty_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :elections, :faculties
  end
end
