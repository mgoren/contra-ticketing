class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.column :email, :string, limit: 255, null: false
      t.column :name, :string, limit: 255
      t.column :phone, :string
      t.column :total, :integer
      t.timestamps
    end
  end
end
