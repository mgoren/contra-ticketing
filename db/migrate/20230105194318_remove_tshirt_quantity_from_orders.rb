class RemoveTshirtQuantityFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :tshirt_quantity
  end
end
