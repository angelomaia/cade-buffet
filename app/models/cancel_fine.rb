class CancelFine < ApplicationRecord
  belongs_to :event_type

  validates :days, :percentage, numericality: { greater_than: 0 }
end
