class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :buffet, null: false, foreign_key: true
      t.references :event_type, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :guest_quantity
      t.string :details
      t.string :code
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.integer :status

      t.timestamps
    end
  end
end
