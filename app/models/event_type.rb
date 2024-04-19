class EventType < ApplicationRecord
  belongs_to :buffet
  has_one :price
  validates :name, :description, :duration, :min_people, :max_people, :menu, presence: true

  enum location: { exclusive: 0, anywhere: 1 }

  def self.extras(event_type_id)
    event_type = EventType.find(event_type_id)
    true_extras = []
    true_extras << :alcohol if event_type.alcohol
    true_extras << :decoration if event_type.decoration
    true_extras << :parking if event_type.parking
    true_extras
  end
end
