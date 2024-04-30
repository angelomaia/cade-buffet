class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event_type
  belongs_to :user

  enum location: { buffet_address: 0, elsewhere: 1 }
  enum status: { pending: 0, approved: 1, confirmed: 2, cancelled: 9}

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(20)
  end
end
