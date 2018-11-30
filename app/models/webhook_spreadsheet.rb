class WebhookSpreadsheet < Webhook
  def initialize(order)
    @payload = order
    @endpoint = ENV['ZAPIER_SPREADSHEET_WEBHOOK_URL']
    super()
  end
end
