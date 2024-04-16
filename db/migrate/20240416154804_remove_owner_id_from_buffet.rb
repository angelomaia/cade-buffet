class RemoveOwnerIdFromBuffet < ActiveRecord::Migration[7.1]
  def change
    remove_column :buffets, :owner_id_id, :string
  end
end
