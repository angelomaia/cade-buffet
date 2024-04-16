class AddOwnerToBuffet < ActiveRecord::Migration[7.1]
  def change
    add_reference :buffets, :owner, null: false, foreign_key: true
  end
end
