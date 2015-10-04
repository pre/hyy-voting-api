class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.string :name, null: false
      t.string :email

      t.timestamps null: false
    end
  end
end
