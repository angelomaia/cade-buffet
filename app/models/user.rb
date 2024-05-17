class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates_cpf_format_of :cpf

  has_many :orders
  has_many :ratings
  has_many :fine_charges
end
