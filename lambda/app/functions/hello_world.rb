# frozen_string_literal: true

# Adds an account to the queue
# See the file docs/lambda_functions/add_to_queue.md for more info.
class HelloWorld < LambdaHandler
  def initialize(event:, context:)
    super(event: event, context: context)
  end

  def process
    name = event['name'] || 'World'
    greeting = "Hello #{name}"

    {
      greeting: greeting
    }
  end
end
