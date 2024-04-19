class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.float :base
      t.float :extra_person
      t.float :extra_hour
      t.float :weekend_base
      t.float :weekend_extra_person
      t.float :weekend_extra_hour
      t.references :event_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
