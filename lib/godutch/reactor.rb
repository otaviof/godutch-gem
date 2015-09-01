require 'godutch/packet'
require 'godutch/status'
require 'json'


module GoDutch
  module Reactor
    include GoDutch::Status

    def receive_data(payload)
      packet = GoDutch::Packet.new(payload.strip)

      # reseting all the buffers we accumulate for a given check
      reset_status_buffer()

      output = { 'check_name' => packet.command() }

      begin
        # trying to call method name on self
        stdout = self.public_send(packet.command())
        # collecting status methods (from GoDutch::Status) buffered data
        output.merge!(read_status_buffer())
        # final return on method is also saved
        output.merge!({ 'stdout' => stdout })
      rescue => e
        output.merge!(
          { 'check_status' => GoDutch::Status::UNKNOWN,
            'error' => e,
          }
        )
      end

      self.send_data("#{output.to_json}\n")
      self.close_connection_after_writing()
    end
  end

  def unbind
    EM.stop_event_loop
  end
end

# EOF
