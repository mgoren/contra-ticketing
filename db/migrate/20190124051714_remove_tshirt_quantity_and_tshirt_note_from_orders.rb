class RemoveTshirtQuantityAndTshirtNoteFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :tshirt_quantity, :integer
    remove_column :orders, :tshirt_note, :string
    remove_column :orders, :tshirt_cost, :integer
  end
end
