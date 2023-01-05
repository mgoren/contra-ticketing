class WebhookSpreadsheet < Webhook
  def initialize(order)
    @payload = {order: order}.to_json
    @endpoint = ENV['ZAPIER_SPREADSHEET_WEBHOOK_URL']
    super()
  end
end
