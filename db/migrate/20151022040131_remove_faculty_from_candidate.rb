class RemoveFacultyFromCandidate < ActiveRecord::Migration
  def change
    remove_column :candidates, :faculty_id
  end
end
