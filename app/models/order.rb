class Order < ApplicationRecord
  validates :name, :email, :phone, :admission_quantity, :admission_cost, :tshirt_quantity, :tshirt_cost, presence: true
  validates :admission_cost, numericality: {only_integer: true, greater_than_or_equal_to: 10, less_than_or_equal_to: 25}
  validates :name, :email, :phone, length: { maximum: 50 }
  validates :tshirt_note, length: { maximum: 255 }
  validates :charge_id, uniqueness: true
  validate :check_total

  before_create :clear_note, if: ->(order) { order.tshirt_quantity == 0 }
  before_create :make_payment
  after_create :send_webhook
  after_create :send_email_receipt

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

  def send_webhook
    Webhook.new(self)
  end

  def send_email_receipt
    url = "https://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}/messages"
    from = "Portland Megaband <no-reply@#{ENV['MAILGUN_DOMAIN']}>"
    subject = "Portland Megaband payment receipt"
    body_text = "Thanks #{name}! Your payment to PCDC for $#{total} has been successfully processed. "
    body_html = "<p>Thanks #{name}! Your payment to PCDC for $#{total} has been successfully processed.</p>"
    body_html += "<p>Name: #{name}<br>Email: #{email}<br>Phone: #{phone}</p>"
    if admission_quantity > 0
      if admission_cost > 10
        donation_amount = (admission_cost - 10) * admission_quantity
        body_text += "Megaband admissions: #{admission_quantity} x $#{admission_cost} = $#{admission_quantity * admission_cost} (of which $#{donation_amount} is a tax-deductible charitable contribution to PCDC) "
        body_html += "<p>Megaband admissions:<br>#{admission_quantity} x $#{admission_cost} = $#{admission_quantity * admission_cost} (of which $#{donation_amount} is a tax-deductible charitable contribution to PCDC)<br>"
      else
        body_text += "Megaband admissions: #{admission_quantity} x $#{admission_cost} = $#{admission_quantity * admission_cost} "
        body_html += "<p>Megaband admissions:<br>#{admission_quantity} x $#{admission_cost} = $#{admission_quantity * admission_cost}<br>"
      end
      body_text += "Your name will be on a list at the door. (You will not receive a physical ticket.) "
      body_html += "<strong>Your name will be on a list at the door. (You will not receive a physical ticket.)</strong></p>"
    end
    if tshirt_quantity > 0
      body_text += "Megaband t-shirts: #{tshirt_quantity} x $#{tshirt_cost} = $#{tshirt_quantity * tshirt_cost} "
      body_html += "<p>Megaband t-shirts:<br>#{tshirt_quantity} x $#{tshirt_cost} = $#{tshirt_quantity * tshirt_cost}<br>#{tshirt_note}</p>"
    end
    body_text += "Please email contra@portlandcountrydance.org if you have any questions."
    body_html += "<p>Please email contra@portlandcountrydance.org if you have any questions.</p>"
    RestClient.post url, from: from, to: email, subject: subject, text: body_text, html: body_html
  end
end
