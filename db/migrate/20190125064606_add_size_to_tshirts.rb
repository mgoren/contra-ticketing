class AddSizeToTshirts < ActiveRecord::Migration[5.2]
  def change
    add_column :tshirts, :size, :string
  end
end
