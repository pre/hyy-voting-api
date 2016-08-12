class RemoveCandidateNumberingOrder < ActiveRecord::Migration[5.0]
  def change
    remove_column :candidates, :numbering_order
  end
end
