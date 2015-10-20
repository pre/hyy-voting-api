class ElectionBelongsToDepartment < ActiveRecord::Migration
  def change
    add_column :elections, :department_id, :integer

    add_foreign_key :elections, :departments
  end
end
