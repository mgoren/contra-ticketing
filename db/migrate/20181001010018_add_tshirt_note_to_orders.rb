class AddTshirtNoteToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :tshirt_note, :string, limit: 255
  end
end
