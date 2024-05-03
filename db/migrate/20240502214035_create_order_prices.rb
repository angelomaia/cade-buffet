class CreateOrderPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :order_prices do |t|
      t.references :order, null: false, foreign_key: true
      t.references :event_type, null: false, foreign_key: true
      t.references :buffet, null: false, foreign_key: true
      t.decimal :base
      t.decimal :discount
      t.decimal :fee
      t.decimal :total
      t.string :payment

      t.timestamps
    end
  end
end
