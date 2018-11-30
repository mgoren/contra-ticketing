class EmailJob < ApplicationJob
  queue_as :default

  def perform(attributes)
    Email.send(attributes)
  end
end
