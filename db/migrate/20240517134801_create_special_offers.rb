class CreateSpecialOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :special_offers do |t|
      t.date :start
      t.date :end
      t.integer :percentage
      t.references :event_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
