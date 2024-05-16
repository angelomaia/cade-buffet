class Rating < ApplicationRecord
  belongs_to :order
  belongs_to :buffet
  belongs_to :event_type
  belongs_to :user
  has_many_attached :photos

  validates :grade, :text, presence: true
  validates :grade, numericality: { in: 1..5 }
  validate :order_must_be_in_the_past

  def self.list(buffet)
    where(buffet: buffet).order(created_at: :desc)
  end

  def self.top_three(buffet)
    where(buffet: buffet).order(created_at: :desc).limit(3)
  end

  private

  def order_must_be_in_the_past
    if self.order.date > Date.today
      self.errors.add(:base, 'Avaliação só pode ser feita para eventos que já aconteceram.')
    end
  end
end
