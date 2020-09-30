class RemoveFacultyAndDepartmentFromElection < ActiveRecord::Migration[5.2]
  def change
    change_table(:elections) do |t|
      t.remove 'faculty_id'
      t.remove 'department_id'
    end
  end
end
