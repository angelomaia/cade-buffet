class Buffet < ApplicationRecord
  belongs_to :owner
  validates :name, :corporate_name, :cnpj, :address, :neighborhood, :city, :state, :email, :phone, :zipcode, presence: true
  validates :cnpj, :corporate_name, uniqueness: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :pix, :debit, :credit, :cash, inclusion: { in: [true, false] }  
  has_many :event_types
  
end
