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
  validate :at_least_one_true

  enum status: { deactivated: 0, active: 1 }

  has_many :event_types
  has_many :orders
  has_many :ratings
  has_many :fine_charges

  def average_rating
    total_ratings = ratings.count
    return nil if total_ratings.zero?

    total_grades = ratings.sum(:grade)
    total_grades.to_f / total_ratings
  end

  def has_any_price?
    event_types.joins(:price).exists?
  end

  def at_least_one_true
    unless pix || debit || credit || cash
      errors.add(:base, "Deve registrar pelo menos um método de pagamento.")
    end
  end
end
