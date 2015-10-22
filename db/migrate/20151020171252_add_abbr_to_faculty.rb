class AddAbbrToFaculty < ActiveRecord::Migration
  def change
    add_column :faculties, :abbr, :string, null: false
  end
end
