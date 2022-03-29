# frozen_string_literal: true

# Adds an account to the queue
# See the file docs/lambda_functions/add_to_queue.md for more info.
class Greeter < LambdaHandler
  def initialize(event:, context:)
    super(event: event, context: context)
  end

  def process
    XRay.recorder.capture('very hard work') do
      sleep(2)
    end

    {
      who_to_greet: [
        {
          name: 'SUSE',
        },
        {
          name: 'Rancher',
        },
        {
          name: 'NeuVector'
        }
      ]
    }
  end
end
