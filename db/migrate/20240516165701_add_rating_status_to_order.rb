class AddRatingStatusToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :rating_status, :integer, default: 0
  end
end
