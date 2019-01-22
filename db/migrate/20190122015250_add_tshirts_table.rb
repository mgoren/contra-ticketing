class AddTshirtsTable < ActiveRecord::Migration[5.2]
  def change
    create_table(:tshirts) do |t|
      t.belongs_to :order

      t.string :style
      t.string :color
      t.integer :cost
    end
  end
end
