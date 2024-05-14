class AddStatusToBuffet < ActiveRecord::Migration[7.1]
  def change
    add_column :buffets, :status, :integer, default: 1
  end
end
