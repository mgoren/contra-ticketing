class DropTshirts < ActiveRecord::Migration[5.2]
  def change
    drop_table :tshirts
  end
end
