# frozen_string_literal: true

# Adds an account to the queue
# See the file docs/lambda_functions/add_to_queue.md for more info.
class HelloWorld < LambdaHandler
  def initialize(event:, context:)
    super(event: event, context: context)
  end

  def process
    greeting = nil
    XRay.recorder.capture('easy task') do
      name = event['name'] || 'World'
      greeting = "Hello #{name}"
    end
    logger.info greeting

    {
      greeting: greeting
    }
  end
end
