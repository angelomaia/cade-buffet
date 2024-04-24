class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, format: { :with => /\A[0-9]+\z/, :message => "Deve conter apenas números" }
end
