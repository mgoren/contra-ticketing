class Email
  def initialize(order)
    EmailJob.perform_later(order)
  end

  def self.send(order)
    url = "https://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v3/#{ENV['MAILGUN_DOMAIN']}/messages"
    from = "Portland Megaband <no-reply@#{ENV['MAILGUN_DOMAIN']}>"
    subject = "Portland Megaband payment receipt"
    body_text = "Thanks #{order.name}! Your payment to PCDC for $#{order.total} has been successfully processed. "
    body_html = "<p>Thanks #{order.name}! Your payment to PCDC for $#{order.total} has been successfully processed.</p>"
    body_html += "<p>Name: #{order.name}<br>Email: #{order.email}<br>Phone: #{order.phone}</p>"
    if order.admission_quantity > 0
      if order.admission_cost > 10
        donation_amount = (order.admission_cost - 10) * order.admission_quantity
        body_text += "Megaband admissions: #{order.admission_quantity} x $#{order.admission_cost} = $#{order.admission_quantity * order.admission_cost} (of which $#{donation_amount} is a tax-deductible charitable contribution to PCDC) "
        body_html += "<p>Megaband admissions:<br>#{order.admission_quantity} x $#{order.admission_cost} = $#{order.admission_quantity * order.admission_cost} (of which $#{donation_amount} is a tax-deductible charitable contribution to PCDC)<br>"
      else
        body_text += "Megaband admissions: #{order.admission_quantity} x $#{order.admission_cost} = $#{order.admission_quantity * order.admission_cost} "
        body_html += "<p>Megaband admissions:<br>#{order.admission_quantity} x $#{order.admission_cost} = $#{order.admission_quantity * order.admission_cost}<br>"
      end
      body_text += "Your name will be on a list at the door. (You will not receive a physical ticket.) "
      body_html += "<strong>Your name will be on a list at the door. (You will not receive a physical ticket.)</strong></p>"
    end
    if order.tshirt_quantity > 0
      body_text += "Megaband t-shirts: #{order.tshirt_quantity} x $#{order.tshirt_cost} = $#{order.tshirt_quantity * order.tshirt_cost} "
      body_html += "<p>Megaband t-shirts:<br>#{order.tshirt_quantity} x $#{order.tshirt_cost} = $#{order.tshirt_quantity * order.tshirt_cost}<br>#{order.tshirt_note}<br>T-shirts can be picked up at the dance.</p>"
    end
    body_text += "Please email contra@portlandcountrydance.org if you have any questions."
    body_html += "<p>Saturday, March 9, 2019<br>7:30 lesson | 8-11:15 dance<br>PSU Smith Memorial Center Ballroom, 3rd Floor<br>1825 SW Broadway, Portland, Oregon</p>"
    body_html += "<p>Paid parking is available in the parking structure across Broadway from the building.</p>"
    body_html += "<p>Please email contra@portlandcountrydance.org if you have any questions.</p>"
    body_html += "<p><a href='http://www.cascadepromenade.org/dance/2019/01/06/Cascade-Promenade-2019.html'>Check out other Cascade Promenade events!</a></p>"
    RestClient.post url, from: from, to: order.email, subject: subject, text: body_text, html: body_html
  end
end
