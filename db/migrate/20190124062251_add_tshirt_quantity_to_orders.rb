class AddTshirtQuantityToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :tshirt_quantity, :integer
  end
end
