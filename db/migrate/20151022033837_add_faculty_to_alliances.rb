class AddFacultyToAlliances < ActiveRecord::Migration
  def change
    add_column :alliances, :faculty_id, :integer
    add_column :alliances, :department_id, :integer

    add_foreign_key :alliances, :faculties
    add_foreign_key :alliances, :departments
  end
end
