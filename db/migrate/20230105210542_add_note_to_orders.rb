class AddNoteToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :note, :text
  end
end
