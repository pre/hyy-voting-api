class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name, null: false
      t.string :name_spare, null: false
      t.integer :number

      t.timestamps null: false
    end
  end
end
