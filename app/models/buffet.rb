class Buffet < ApplicationRecord
  belongs_to :owner
  validates :name, :corporate_name, :cnpj, :address, :neighborhood, :city, :state, :email, :phone, :zipcode, presence: true
  validates :cnpj, :corporate_name, :email, uniqueness: true
end
