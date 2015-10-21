class AddUniqueIndexToFaculties < ActiveRecord::Migration
  def change
    add_index :faculties, :code, unique: true
    add_index :departments, :code, unique: true
  end
end
