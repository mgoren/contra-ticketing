class Webhook
  attr_reader :payload

  def initialize(attributes)
    @payload = attributes
    WebhookJob.perform_later({ payload: payload })
  end

  def self.send(attributes)
    response = RestClient.post(ENV['ZAPIER_WEBHOOK_URL'], attributes[:payload].to_json)
    raise response.to_s if response.code >= 400
    response
  end
end
