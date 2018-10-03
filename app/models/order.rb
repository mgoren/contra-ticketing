class Order < ApplicationRecord
  validates :name, :email, :phone, :admission_quantity, :admission_cost, :tshirt_quantity, :tshirt_cost, presence: true
  validates :admission_cost, numericality: {only_integer: true, greater_than_or_equal_to: 10, less_than_or_equal_to: 25}
  validates :name, :email, :phone, length: { maximum: 50 }
  validates :tshirt_note, length: { maximum: 255 }
  validate :check_total

  before_save :make_payment

  attr_accessor :stripe_token, :idempotency_key
private

  def check_total
    unless total == admission_quantity * admission_cost + tshirt_quantity * tshirt_cost
      errors.add(:custom, "Error calculating total. Your card was not charged.")
    end
  end

  def make_payment
    begin
      charge = Stripe::Charge.create({
          amount: total * 100,
          currency: 'usd',
          source: stripe_token,
          description: 'Megaband ' + email,
          statement_descriptor: 'PCDC Megaband'
      }, {
        idempotency_key: idempotency_key
        })
        self.charge_id = charge.id
    rescue Stripe::CardError => e
      errors.add(:custom, e.message)
      throw :abort
    end
  end
end
