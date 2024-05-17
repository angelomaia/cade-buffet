class CreateFineCharges < ActiveRecord::Migration[7.1]
  def change
    create_table :fine_charges do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :buffet, null: false, foreign_key: true
      t.float :value

      t.timestamps
    end
  end
end
