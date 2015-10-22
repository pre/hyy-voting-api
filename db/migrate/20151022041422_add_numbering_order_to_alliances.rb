class AddNumberingOrderToAlliances < ActiveRecord::Migration
  def change
    add_column :alliances, :numbering_order, :integer
  end
end
