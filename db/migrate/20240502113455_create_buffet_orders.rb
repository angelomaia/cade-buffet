class CreateBuffetOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :buffet_orders do |t|
      t.references :buffet, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.references :event_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
