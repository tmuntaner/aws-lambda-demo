# frozen_string_literal: true

# Base Class for Lambda Handlers
class LambdaHandler
  attr_reader :logger, :event, :context, :body

  def initialize(event:, context:, logger: nil)
    @logger = logger || Logger.new($stdout)
    @event = event
    @context = context
    @body = event['body'].nil? ? {} : JSON.parse(@event['body'])

    @logger.info('## EVENT')
    event.each { |k, v| @logger.info "#{k}: #{v}" }
  end

  protected

  def success_response(message:)
    logger.info(message)

    { statusCode: 200, body: JSON.generate({ message: message }) } unless @body.empty?
  end
end
