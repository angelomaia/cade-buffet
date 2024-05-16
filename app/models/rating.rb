class Rating < ApplicationRecord
  belongs_to :order
  belongs_to :buffet
  belongs_to :event_type
  belongs_to :user
  has_many_attached :photos

  validates :grade, :text, presence: true
  validates :grade, numericality: { in: 0..5 }
  validate :order_must_be_in_the_past
  validate :order_must_be_unrated

  def self.list(buffet)
    where(buffet: buffet).order(created_at: :desc)
  end

  def self.top_three(buffet)
    where(buffet: buffet).order(created_at: :desc).limit(3)
  end

  private

  def order_must_be_unrated
    if self.order.rated?
      self.errors.add(:base, 'Avaliação só pode ser feita uma vez por pedido.')
    end
  end

  def order_must_be_in_the_past
    if self.order.date > Date.today
      self.errors.add(:base, 'Avaliação só pode ser feita para eventos que já aconteceram.')
    end
  end
end
