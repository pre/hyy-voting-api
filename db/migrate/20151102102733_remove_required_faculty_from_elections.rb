class RemoveRequiredFacultyFromElections < ActiveRecord::Migration
  def change
    change_column :elections, :faculty_id, :integer, null: true
  end
end
