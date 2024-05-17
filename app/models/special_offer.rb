class SpecialOffer < ApplicationRecord
  belongs_to :event_type

  validates :percentage, numericality: { in: 0..100 }
end
