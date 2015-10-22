class AddPhoneToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :phone, :string
  end
end
