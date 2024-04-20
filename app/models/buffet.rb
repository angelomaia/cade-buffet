class Buffet < ApplicationRecord
  belongs_to :owner
  validates :name, :corporate_name, :cnpj, :address, :neighborhood, :city, :state, :email, :phone, :zipcode, presence: true
  validates :cnpj, :corporate_name, :email, uniqueness: true
  validates :pix, :debit, :credit, :cash, inclusion: { in: [true, false] }  
  has_many :event_types
end
