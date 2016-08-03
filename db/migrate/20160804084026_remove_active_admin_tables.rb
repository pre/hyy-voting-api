class RemoveActiveAdminTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :active_admin_comments
    drop_table :admin_users
  end
end
