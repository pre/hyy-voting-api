class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.integer :faculty_id

      t.timestamps null: false
    end

    add_foreign_key :departments, :faculties
  end
end
