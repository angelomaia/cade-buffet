class FineCharge < ApplicationRecord
  belongs_to :order
  belongs_to :user
  belongs_to :buffet

  enum status: { pending: 0, paid: 1 }
end
