class CreateBuffetMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :buffet_messages do |t|
      t.string :content
      t.references :chat, null: false, foreign_key: true
      t.references :buffet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
