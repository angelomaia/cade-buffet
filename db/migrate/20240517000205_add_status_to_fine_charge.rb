class AddStatusToFineCharge < ActiveRecord::Migration[7.1]
  def change
    add_column :fine_charges, :status, :integer, default: 0
  end
end
