class VoterBelongsToDepartment < ActiveRecord::Migration
  def change
    add_column :voters, :department_id, :integer

    add_foreign_key :voters, :departments
  end
end
