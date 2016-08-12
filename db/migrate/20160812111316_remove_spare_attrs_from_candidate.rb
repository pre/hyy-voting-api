class RemoveSpareAttrsFromCandidate < ActiveRecord::Migration[5.0]
  def change
    remove_column :candidates, :spare_firstname
    remove_column :candidates, :spare_lastname
  end
end
