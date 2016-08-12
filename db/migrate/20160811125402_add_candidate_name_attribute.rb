class AddCandidateNameAttribute < ActiveRecord::Migration[5.0]
  def change
    change_table :candidates do |t|
      t.string :candidate_name
    end
  end
end
