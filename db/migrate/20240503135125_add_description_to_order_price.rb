class AddDescriptionToOrderPrice < ActiveRecord::Migration[7.1]
  def change
    add_column :order_prices, :description, :string
  end
end
