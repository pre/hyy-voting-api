class AddFacultyToVoter < ActiveRecord::Migration
  def change
    add_column :voters, :faculty_id, :integer, null: false

    add_foreign_key :voters, :faculties
  end
end
