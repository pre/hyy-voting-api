class RemoveIndexOnStudentNumber < ActiveRecord::Migration
  def change
    remove_index :voters, name: :index_voters_on_student_number
  end
end
