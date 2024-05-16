class CreateCancelFines < ActiveRecord::Migration[7.1]
  def change
    create_table :cancel_fines do |t|
      t.integer :days
      t.integer :percentage
      t.references :event_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
