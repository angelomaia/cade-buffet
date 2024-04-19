class CreateEventTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :event_types do |t|
      t.string :name
      t.string :description
      t.string :min_people
      t.string :max_people
      t.string :duration
      t.string :menu
      t.boolean :alcohol
      t.boolean :decoration
      t.boolean :parking
      t.integer :location, default: 0
      t.references :buffet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
