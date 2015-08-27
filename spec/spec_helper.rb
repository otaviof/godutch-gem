# replace the require_relative adding all inside library onto the PATH
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# require 'em-rspec'
require 'godutch'
require 'godutch/reactor'
# require 'eventmachine'
require 'json'

RSpec.configure do |config|
   config.expect_with :rspec do |expectations|
    expectations.syntax = :should, :expect
  end
   config.raise_errors_for_deprecations!
end

# EOF
