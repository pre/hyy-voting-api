class RemoveUniquenesOnVoterSsn < ActiveRecord::Migration[7.0]
  def change
    remove_index "voters", column: [:ssn], name: "index_voters_on_ssn"
  end
end
