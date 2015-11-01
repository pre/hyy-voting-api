class RemoveNotNullFromStudentNumber < ActiveRecord::Migration
  def change
    change_column :voters, :student_number, :string, null: true
  end
end
