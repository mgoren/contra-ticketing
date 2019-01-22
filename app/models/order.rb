class Order < ApplicationRecord
  has_many :tshirts

  before_validation :merge_config_values
  validates :name, :email, :phone, :admission_quantity, presence: true
  validates :name, :email, :phone, length: { maximum: 255 }
  validates :charge_id, uniqueness: true
  validate :validate_configured_fields
  validate :validate_total

  before_create :make_payment
  after_create :add_to_spreadsheet

  attr_accessor :stripe_token, :idempotency_key

  accepts_nested_attributes_for :tshirts

private

  def merge_config_values
    self.admission_cost = Rails.configuration.order[:admission_cost] unless Rails.configuration.order[:admission_cost] == 0 # unless sliding scale
  end

  def validate_configured_fields
    if Rails.configuration.order[:admission_cost] == 0 && !admission_cost.between?(Rails.configuration.order[:sliding_scale_min], Rails.configuration.order[:sliding_scale_max])
      errors.add(:custom, "Something weird went wrong. Admission cost is not in valid range.")
    end
  end

  def validate_total
    back_end_total = admission_quantity * admission_cost
    tshirts.each { |tshirt| back_end_total += tshirt.cost }
    if total != back_end_total
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

  def add_to_spreadsheet
    WebhookSpreadsheet.new(self)
  end

  def send_receipt
    Email.new(self)
  end
end
