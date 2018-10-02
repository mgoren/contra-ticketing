class AddDetailsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :admission_quantity, :integer
    add_column :orders, :admission_cost, :integer
    add_column :orders, :tshirt_quantity, :integer
    add_column :orders, :tshirt_cost, :integer
  end
end
