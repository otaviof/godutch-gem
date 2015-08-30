require 'godutch/packet'
require 'json'


module GoDutch
  module Reactor
    def receive_data(payload)
      packet = GoDutch::Packet.new(payload.strip)

      output = nil
      begin
        output = self.public_send(packet.command)
        output = { 'output' => output }.to_json
      rescue => e
        output = {
          'command' => packet.command,
          'error' => e,
        }.to_json
      end

      self.send_data("#{output}\n")
      self.close_connection_after_writing()
    end
  end

  def unbind
    EM.stop_event_loop
  end
end

# EOF
