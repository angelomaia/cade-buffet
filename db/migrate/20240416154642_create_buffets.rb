class CreateBuffets < ActiveRecord::Migration[7.1]
  def change
    create_table :buffets do |t|
      t.string :name
      t.string :corporate_name
      t.string :cnpj
      t.string :phone
      t.string :email
      t.string :address
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :description
      t.boolean :pix
      t.boolean :debit
      t.boolean :credit
      t.boolean :cash
      t.references :owner_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
