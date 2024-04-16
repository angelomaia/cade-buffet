class AddBuffetToOwner < ActiveRecord::Migration[7.1]
  def change
    add_reference :owners, :buffet, foreign_key: true
  end
end
