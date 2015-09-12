require 'json'


# replace the require_relative adding all inside library onto the PATH
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'godutch'
require 'godutch/reactor'
require 'godutch/packet'
require 'godutch/status'
require 'godutch/metrics'
require 'godutch/helper'


module Helpers
  # JSON returns a different error code on Windows, so simulating this
  # exception and saving to create the expected output.
  def json_exception(input=nil)
    json_error = nil
    begin
      JSON.parse(input)
    rescue JSON::ParserError => e
      json_error = e
    end

    return json_error
  end
end


RSpec.configure do |config|
  config.include(Helpers)
  config.expect_with :rspec do |expectations|
    expectations.syntax = :should, :expect
  end
  config.raise_errors_for_deprecations!
end

# EOF
