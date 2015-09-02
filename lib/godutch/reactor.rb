require 'godutch/helper'
require 'godutch/packet'
require 'godutch/status'
require 'godutch/metrics'
require 'json'


module GoDutch
  # Meant to work as a EventMachine reactor, adding a thin wrapper to a custom
  # monitoring module. Adds the ability to call and list avaiable checks.
  module Reactor
    include GoDutch::Helper
    include GoDutch::Status
    include GoDutch::Metrics


    # Implements 'receive_data' for EventMachine, and here it parsers the
    # payload, should be JSON, and extracts the command which is called on
    # 'self' and wrapped up for JSON response transport joining output
    # (return), GoDutch::Status and GoDutch::Metrics buffers.
    #   +payload+   Ruby hash represented as JSON, a valid GoDutch packet;
    def receive_data(payload)
      packet = GoDutch::Packet.new(payload.strip)
      command = packet.command()
      output = { 'check_name' => command }

      # inspecting code for local check names and helper methods
      @helper_methods ||= __list_helper_methods()
      @check_methods ||= __list_check_methods()

      begin
        # calling internal and externally defined commands, tranlated into
        # Module's method names, and for security and configurational reasons
        # only checks that matches pre-defined names will be called
        case
        when @helper_methods.include?(command)
          # only calling method name
          stdout = self.public_send(command)
        when @check_methods.include?(command)
          # reseting all the buffers we accumulate for a given check
          reset_status_buffer()
          reset_metrics_buffer()
          # calling method with command name
          stdout = self.public_send(command)
          # collecting output of status methods (from GoDutch::Status)
          output.merge!(read_status_buffer())
          # collecting metrics (from GoDutch::Metrics)
          output.merge!({ 'metrics' => read_metrics_buffer() })
        else
          raise "[ERROR] Invalid command: '#{command}'"
        end
        # final return on method is also saved
        output.merge!({ 'stdout' => stdout })
      rescue => e
        output.merge!(
          { 'check_status' => GoDutch::Status::UNKNOWN,
            'error' => e,
          }
        )
      end

      # calling methods from EventMachine, to communicate only once and close
      # the connection right after
      self.send_data("#{output.to_json}\n")
      self.close_connection_after_writing()
    end
  end

  # Implements 'unbind' method for EM, stopping event loop when called.
  def unbind
    EM.stop_event_loop
  end
end

# EOF
