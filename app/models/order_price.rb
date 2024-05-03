class OrderPrice < ApplicationRecord
  belongs_to :order
  belongs_to :event_type
  belongs_to :buffet

  validates :base, :expiration_date, :payment, presence: true
  validates :discount, :fee, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  validate :expiration_date_is_in_the_future
  validate :discount_value
  validate :discount_or_fee

  private 

  def expiration_date_is_in_the_future
    if self.expiration_date.present? && self.expiration_date <= Date.today
      self.errors.add(:expiration_date, "deve ser no futuro.")
    end
  end

  def discount_value
    if self.discount.present? && self.discount > self.base
      self.errors.add(:discount, "deve ser menor ou igual a #{self.base}")
    end
  end

  def discount_or_fee
    if self.discount.present? && self.fee.present? && self.fee > 0 && self.discount > 0
      self.errors.add(:base, "Deve aplicar apenas um desconto ou uma taxa extra.")
    end
  end
end
