# frozen_string_literal: true

require_relative 'config/boot'

def hello_world(event:, context:)
  HelloWorld.new(event: event, context: context).process
end

def greeter(event:, context:)
  Greeter.new(event: event, context: context).process
end
