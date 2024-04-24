class Price < ApplicationRecord
  belongs_to :event_type
  validates :base, :extra_person, :extra_hour, :weekend_base, :weekend_extra_person, :weekend_extra_hour, numericality: { allow_blank: true }
  validates :base, :extra_person, :extra_hour, presence: true
end
