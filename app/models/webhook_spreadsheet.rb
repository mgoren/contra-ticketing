class WebhookSpreadsheet < Webhook
  def initialize(order)
    @payload = {order: order, tshirts: order.tshirts.map {|tshirt| TshirtSerializer.new(tshirt)}}.to_json
    @endpoint = ENV['ZAPIER_SPREADSHEET_WEBHOOK_URL']
    super()
  end
end
