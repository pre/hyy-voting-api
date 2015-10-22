class AddActualCandidateFieds < ActiveRecord::Migration
  def change

    remove_column :candidates, :name
    remove_column :candidates, :name_spare
    remove_column :candidates, :number

    add_column :candidates, :firstname, :string, null: false
    add_column :candidates, :lastname, :string, null: false
    add_column :candidates, :spare_firstname, :string, null: false
    add_column :candidates, :spare_lastname, :string, null: false
    add_column :candidates, :ssn, :string
    add_column :candidates, :faculty_id, :integer, null: false
    add_column :candidates, :candidate_number, :integer
    add_column :candidates, :numbering_order, :integer
  end
end
