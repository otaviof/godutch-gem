require 'json'
require 'eventmachine'

# replace the require_relative adding all inside library onto the PATH
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'godutch'
require 'godutch/reactor'
require 'godutch/packet'
require 'godutch/status'
require 'godutch/metrics'
require 'godutch/helper'

# General JSON helper during rspec tests.
module JSONHelper
  # JSON returns a different error code on Windows, so simulating this
  # exception and saving to create the expected output.
  def json_exception(input = nil)
    json_error = nil
    begin
      JSON.parse(input)
    rescue JSON::ParserError => e
      json_error = e
    end
    json_error
  end
end

# RSpec helper to event-machine, heavily inspired on russian blog post:
#   http://habrahabr.ru/post/126231
module RSpecEM
  # EM connection client to be used during RSpec tests. Able to send `payload`
  # into socket and read it's response.
  module Client
    # Received data callback.
    #   +payload+  response read on socket;
    def receive_data(payload)
      # calling block saved on `send_request` method, with received payload
      # as argument
      @onresponse.call(payload)
      # when response is done, closing the socket by default
      @onclose.call
    end

    # Right after connecting, it sends the payload, when we have response, the
    # `block` parameter will be yield by EM.
    #   +payload+  string to be written into the socket;
    #   +block+    code-block to yield on-response;
    def send_request(payload, &block)
      # to be executed (yielded) when there's response from socket
      @onresponse = block
      send_data(payload)
    end

    # Handles the onclose event, adding a code-block.
    #   +proc+  block to yield right after `onclose`;
    def onclose=(proc)
      @onclose = proc
    end

    # Maps the unbind to `onclose` event.
    def unbind
      @onclose.call
    end
  end

  # Creates a simple EM server to around informed `reactor` module on a
  # unix type of socket.
  module Server
    include RSpecEM::Client

    # Entry point of this module. It creates a socket and also the dummy-client
    # where it calls the `request` after server is spawned.
    #   +reactor+  GoDutch reactor module, or any EM compatile code;
    #   +request+  string with client's request;
    def spawn_reactor(reactor, request)
      time = Time.now
      start_reactor(reactor) do |client|
        client.send_request(request) do |resp|
          # assuming that response data will always be a JSON
          yield JSON.parse(resp)
        end
        client.onclose = -> { EM.stop }
        timer(time)
      end
    end

    # Creates the EM server on hardcoded socket file.
    #   +reactor+  Module on which we will spawn event-machine;
    def start_reactor(reactor)
      sock_file = '/tmp/rspec-godutch_spec.sock'
      File.unlink(sock_file) if File.exist?(sock_file)
      EM.run do
        EventMachine.start_unix_domain_server(sock_file, reactor)
        client = EM.connect_unix_domain(sock_file, RSpecEM::Client)
        yield client
      end
    end

    # Creates a time by default, which will fail the test after 6 seconds.
    def timer(start)
      timeout = 6
      EM.add_timer(timeout) do
        (Time.now - start).should be_within(0).of(timeout)
        EM.stop
      end
    end
  end
end

#### RSspec Configuration #####################################################
#

RSpec.configure do |config|
  config.include(JSONHelper, RSpecEM::Client, RSpecEM::Server)
  config.expect_with :rspec do |expectations|
    expectations.syntax = :should, :expect
  end
  config.raise_errors_for_deprecations!
end

# EOF
