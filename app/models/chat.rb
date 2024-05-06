class Chat < ApplicationRecord
  belongs_to :order

  has_many :user_messages
  has_many :buffet_messages

  def messages
    user_messages = UserMessage.where(chat: self)
    buffet_messages = BuffetMessage.where(chat: self)

    (user_messages + buffet_messages).sort_by { |message| message.created_at }
  end
end
