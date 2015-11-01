class RemoveAbbrFromFaculty < ActiveRecord::Migration
  def change
    remove_column :faculties, :abbr
  end
end
