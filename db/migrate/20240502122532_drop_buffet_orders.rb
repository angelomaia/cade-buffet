class DropBuffetOrders < ActiveRecord::Migration[7.1]
  def change
    drop_table :buffet_orders
  end
end
