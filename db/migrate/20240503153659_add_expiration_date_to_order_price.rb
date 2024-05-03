class AddExpirationDateToOrderPrice < ActiveRecord::Migration[7.1]
  def change
    add_column :order_prices, :expiration_date, :date
  end
end
