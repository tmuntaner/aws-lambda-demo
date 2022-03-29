# frozen_string_literal: true

load_paths = Dir[File.expand_path(File.join(File.dirname(__FILE__), '../../vendor/bundle/ruby/2.7.0/gems/**/lib'))]
$LOAD_PATH.unshift(*load_paths)

require 'aws-sdk-lambda'
require 'logger'
require 'json'

client = Aws::Lambda::Client.new
client.get_account_settings

require 'aws-xray-sdk/lambda'

# Require local files
require_relative '../../app/functions/lambda_handler'
Dir[File.expand_path(File.join(File.dirname(__FILE__), '../../app/functions/**/*.rb'))].sort.each { |f| require_relative f }
