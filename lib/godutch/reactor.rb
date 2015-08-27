require 'godutch/packet'

module GoDutch
  module Reactor
    def receive_data(payload)
      packet = GoDutch::Packet.new(payload)

      raise "Called command '#{packet.command}' can't be found." \
        unless self.respond_to?(packet.command)

      return self.public_send(packet.command)
    end
  end
end

# EOF
