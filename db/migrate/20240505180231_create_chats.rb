class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
