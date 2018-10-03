class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.column :email, :string, limit: 255, null: false
      t.column :name, :string, limit: 255, null: false
      t.column :phone, :string, limit: 255, null: false
      t.column :admission_quantity, :integer
      t.column :admission_cost, :integer
      t.column :tshirt_quantity, :integer
      t.column :tshirt_cost, :integer
      t.column :tshirt_note, :string, limit: 255
      t.column :charge_id, :string
      t.column :total, :integer
      t.timestamps
    end

    add_index :orders, :charge_id, unique: true
  end
end
