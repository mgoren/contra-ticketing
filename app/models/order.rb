class Order < ApplicationRecord
  validates :name, :email, :phone, :admission_quantity, :admission_cost, :tshirt_quantity, :tshirt_cost, presence: true
  validates :admission_cost, numericality: {only_integer: true, greater_than_or_equal_to: 10, less_than_or_equal_to: 25}
  validates :name, :email, :phone, length: { maximum: 50 }
  validates :tshirt_note, length: { maximum: 255 }
  validates :charge_id, uniqueness: true
  validate :check_total

  before_create :clear_note, if: ->(order) { order.tshirt_quantity == 0 }
  before_create :make_payment

  attr_accessor :stripe_token, :idempotency_key
private

  def clear_note
    self.tshirt_note = nil
  end

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
        if Order.find_by(charge_id: charge.id)
          errors.add(:duplicate, 'Duplicate form submission blocked.')
          throw :abort
        else
          self.charge_id = charge.id
        end
    rescue Stripe::CardError => e
      errors.add(:custom, e.message)
      throw :abort
    end
  end
end
