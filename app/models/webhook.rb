class Webhook
  attr_reader :endpoint, :payload

  def initialize
    WebhookJob.perform_later({ endpoint: endpoint, payload: payload })
  end

  def self.send(attributes)
    response = RestClient.post(attributes[:endpoint], attributes[:payload])
    raise response.to_s if response.code >= 400
    response
  end
end
