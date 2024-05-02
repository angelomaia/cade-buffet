class Buffet < ApplicationRecord
  belongs_to :owner

  validates :name, :corporate_name, :cnpj, :address, :neighborhood, :city, :state, :email, :phone, :zipcode, presence: true
  validates :cnpj, :corporate_name, uniqueness: true
  validates :cnpj, :phone, :zipcode, format: { :with => /\A[0-9]+\z/, :message => "Deve conter apenas números" }
  validates :zipcode, length: { is: 8, :message => "Deve conter 8 dígitos." }
  validates :phone, length: { in: 10..11, :message => "Deve conter entre 10 a 11 dígitos."}
  validates :email, presence: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }

  validates :pix, :debit, :credit, :cash, inclusion: { in: [true, false] }  

  has_many :event_types
  has_many :orders
end
