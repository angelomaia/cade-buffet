class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event_type
  belongs_to :user
  validates :date, :guest_quantity, presence: true
  validates :guest_quantity, numericality: true
  validate :date_is_future
  validate :address_mandatory_if_location_elsewhere
  validate :guest_quantity_within_bounds

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

  def guest_quantity_within_bounds
    if self.guest_quantity.present? && self.guest_quantity < self.event_type.min_people.to_i
      self.errors.add(:guest_quantity, "deve ser maior que #{self.event_type.min_people.to_i}.")
    elsif self.guest_quantity.present? && self.guest_quantity > self.event_type.max_people.to_i
      self.errors.add(:guest_quantity, "deve ser menor que #{self.event_type.max_people.to_i}.")
    end
  end
end
