class CreateUserMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :user_messages do |t|
      t.string :content
      t.references :chat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
