class AddFacultyAbbreviation < ActiveRecord::Migration[7.2]
  def change
    add_column :faculties, :abbreviation, :string, null: false

    add_index :faculties, :abbreviation, unique: true
  end
end
