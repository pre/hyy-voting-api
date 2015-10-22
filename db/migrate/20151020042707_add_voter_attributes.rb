class AddVoterAttributes < ActiveRecord::Migration
  def change
    add_column :voters, :ssn, :string, null: false
    add_column :voters, :student_number, :string, null: false
    add_column :voters, :start_year, :integer
    add_column :voters, :extent_of_studies, :integer

    add_index :voters, :ssn, unique: true
    add_index :voters, :student_number, unique: true
    add_index :voters, :email
  end
end
