class AddLocationToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :location, :integer, default: 0
  end
end
