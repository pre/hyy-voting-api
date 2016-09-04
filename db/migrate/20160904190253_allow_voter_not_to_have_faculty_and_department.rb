class AllowVoterNotToHaveFacultyAndDepartment < ActiveRecord::Migration[5.0]
  def change
    change_column :voters, :faculty_id, :integer, null: true
    change_column :voters, :department_id, :integer, null: true
  end
end
