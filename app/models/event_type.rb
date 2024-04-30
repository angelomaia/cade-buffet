class EventType < ApplicationRecord
  belongs_to :buffet
  has_one :price
  has_one_attached :cover_photo
  accepts_nested_attributes_for :price
  has_many :orders
  
  validates :name, :description, :duration, :min_people, :max_people, :menu, presence: true
  validates :duration, :min_people, :max_people, format: { :with => /\A[0-9]+\z/, :message => "Deve conter apenas números" }

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
