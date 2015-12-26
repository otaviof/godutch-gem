require 'godutch/helper'
require 'godutch/packet'
require 'godutch/status'
require 'godutch/metrics'
require 'eventmachine'
require 'json'

module GoDutch
  # Meant to work as a EventMachine reactor, adding a thin wrapper to a custom
  # monitoring module. Intercepts all the STDIN input and replies on the same
  # fashion, where case of error it will use the STDERR interface. This
  # implements input and output using the GoDutch simple procolo encapsulated
  # in JSON format.
  module Reactor
    include EM::Protocols::LineProtocol
    include GoDutch::Helper
    include GoDutch::Status
    include GoDutch::Metrics

    # Method to handle unix-socket EM interface
    #   +payload+  unix-socket payload;
    def receive_line(payload = nil)
      @payload = payload
      @output = {}
      @command = nil
      begin
        parse_input_packet
        extract_helper_methods
        execute_command
      rescue => e
        @output = {
          'name' => @command,
          'status' => GoDutch::Status::UNKNOWN,
          'error' => e
        }
      end
      send_data(@output.to_json)
      close_connection_after_writing
    end

    # Transforms input JSON into a packet or raise exception, using attribute
    # variable @payload as input for packet parser.
    def parse_input_packet
      packet = GoDutch::Packet.new(@payload)
      @command = packet.command
    end

    # Inspecting code for local check names and helper methods. Check for
    # GoDutch::Helper code and documentation for more.
    def extract_helper_methods
      @helper_methods ||= __list_helper_methods
      @check_methods ||= __list_check_methods
    end

    # Trigger a method inside informed reactor module. Look for the command
    # name and remaps into reactor's function.
    def execute_command
      # initializing output with command name
      @output = { 'name' => @command }
      # where command converted into method will store it's return
      command_output = []

      case
      when @helper_methods.include?(@command)
        # only calling method name
        command_output << public_send(@command)
      when @check_methods.include?(@command)
        # reseting all the buffers we accumulate for a given check
        reset_status_buffer
        reset_metrics_buffer
        # calling method with command name
        command_output << public_send(@command)
        # collecting output of status methods (from GoDutch::Status)
        @output.merge!(read_status_buffer)
        # collecting metrics (from GoDutch::Metrics)
        @output['metrics'] = read_metrics_buffer
      else
        fail "[ERROR] Invalid command: '#{@command}'"
      end

      # final return on method is also saved
      @output['stdout'] = command_output.flatten
    end
  end
end

# EOF
