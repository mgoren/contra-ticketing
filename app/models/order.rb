class Order < ApplicationRecord
  before_validation :merge_config_values
  before_validation :clear_unused_fields
  validates :name, :email, :phone, :admission_quantity, presence: true
  validates :name, :email, :phone, length: { maximum: 255 }
  validates :charge_id, uniqueness: true
  validate :validate_configured_fields
  validate :validate_total

  before_create :make_payment
  after_create :add_to_spreadsheet
  # after_create :send_receipt # now sending through zapier

  attr_accessor :stripe_token, :idempotency_key

private

  def merge_config_values
    self.admission_cost = Rails.configuration.order[:admission_cost] unless Rails.configuration.order[:admission_cost] == 0 # unless sliding scale
    self.tshirt_cost = Rails.configuration.order[:tshirt_cost] if Rails.configuration.order[:tshirts_available]
  end

  def clear_unused_fields
    self.tshirt_note = nil unless Rails.configuration.order[:tshirts_available] && tshirt_quantity > 0
  end

  def validate_configured_fields
    if Rails.configuration.order[:admission_cost] == 0 && !admission_cost.between?(Rails.configuration.order[:sliding_scale_min], Rails.configuration.order[:sliding_scale_max])
      errors.add(:custom, "Something weird went wrong. Admission cost is not in valid range.")
    end
    if Rails.configuration.order[:tshirts_available] && tshirt_quantity.blank?
      errors.add(:custom, "Something weird went wrong. T-shirt quantity is missing.")
    elsif Rails.configuration.order[:tshirts_available] && tshirt_quantity > 0 && (tshirt_note.blank? || tshirt_note.length > 255)
      errors.add(:custom, "Please include a note with styles, sizes, and colors for any t-shirts.")
    end
  end

  def validate_total
    back_end_total = admission_quantity * admission_cost
    back_end_total += tshirt_quantity * tshirt_cost if Rails.configuration.order[:tshirts_available]
    unless total == back_end_total
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
