class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event_type
  belongs_to :user

  has_one :order_price
  has_one :chat

  validates :date, :guest_quantity, presence: true
  validates :guest_quantity, numericality: true
  validate :date_is_future
  validate :address_mandatory_if_location_elsewhere
  validate :max_guest_quantity
  validate :event_type_needs_to_have_prices

  enum location: { buffet_address: 0, elsewhere: 1 }
  enum status: { pending: 0, approved: 1, confirmed: 2, cancelled: 9}

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(20)
  end

  def date_is_future
    if self.date.present? && self.date <= Date.today
      self.errors.add(:date, "deve ser no futuro.")
    end
  end

  def address_mandatory_if_location_elsewhere
    self.errors.add(:address, "deve ser preenchido.") if self.location == 'elsewhere' && self.address == ''
    self.errors.add(:city, "deve ser preenchido.") if self.location == 'elsewhere' && self.city == ''
    self.errors.add(:state, "deve ser preenchido.") if self.location == 'elsewhere' && self.state == ''
    self.errors.add(:zipcode, "deve ser preenchido.") if self.location == 'elsewhere' && self.zipcode == ''
    if self.location == 'elsewhere' && self.zipcode != ''
      self.errors.add(:zipcode, "deve conter apenas números") unless zipcode.match?(/\A[0-9]+\z/)
      self.errors.add(:zipcode, "deve conter 8 dígitos.") if self.zipcode.length != 8
    end
  end

  def max_guest_quantity
    if self.guest_quantity.present? && self.guest_quantity > self.event_type.max_people.to_i
      self.errors.add(:guest_quantity, "deve ser menor ou igual a #{self.event_type.max_people.to_i}.")
    end
  end

  def event_type_needs_to_have_prices
    if self.event_type.price == nil
      self.errors.add(:event_type_id, "deve ter preços definidos.")
    end
  end
end
