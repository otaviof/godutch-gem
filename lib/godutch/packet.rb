require 'json'

module GoDutch
  # Defines how a Packet, or in orther words a query received from GoDutch
  # master daemon is translated into Ruby.
  class Packet
    attr_accessor :command, :arguments

    @@payload = nil

    def initialize payload=nil
      @@payload = payload
      parse_payload
    end

    # Parses informed JSON payload into command and arguments attributes,
    # which can be read using attr_accessor
    def parse_payload
      parsed = JSON.parse(@@payload)
      @command = parsed['command'].to_s
      @arguments = parsed['arguments']
    rescue JSON::ParserError => e
      raise "Error on parsing JSON: '#{e}'"
    end
  end
end

# EOF
