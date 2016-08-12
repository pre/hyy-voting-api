class CandidateSpareIsNotRequiredInEdari < ActiveRecord::Migration[5.0]
  def change
    change_column :candidates, :spare_firstname, :string, null: true
    change_column :candidates, :spare_lastname, :string, null: true
  end
end
