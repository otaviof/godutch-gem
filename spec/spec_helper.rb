require 'socket'
require 'godutch'
require 'json'


# replace the require_relative adding all inside library onto the PATH
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'godutch'
require 'godutch/reactor'
require 'godutch/packet'


RSpec.configure do |config|
   config.expect_with :rspec do |expectations|
    expectations.syntax = :should, :expect
  end
   config.raise_errors_for_deprecations!
end

# EOF
