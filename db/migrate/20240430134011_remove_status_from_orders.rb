class RemoveStatusFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :status, :integer
  end
end
