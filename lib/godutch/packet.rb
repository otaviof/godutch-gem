require 'json'


module GoDutch
  # Defines how a Packet, or in orther words a query received from GoDutch
  # master daemon is translated into Ruby.
  class Packet
    attr_accessor :command, :arguments

    @@payload = nil
    @command = nil
    @arguments = nil

    # Constructor. Creates a new Packet with contains decoded JSON payload as
    # instance attributes.
    #   +payload+   JSON object, default 'nil';
    def initialize payload=nil
      @@payload = payload
      parse_payload()
      validate()
    end

    # Parses informed JSON payload into command and arguments attributes,
    # which can be read using attr_accessor
    def parse_payload
      begin
        parsed = JSON.parse(@@payload)
        @command = parsed['command'].to_s
        @arguments = parsed['arguments']
      rescue JSON::ParserError => e
        raise "Error on parsing JSON: '#{e}'"
      end
    end

    # Validates the payload informed. It will return first if the arguments
    # are valid and if not, the end of execution, it will raise.
    def validate
      return if not @command.nil? and not @arguments.nil?
      return if @arguments.instance_of?(Array)

      raise "Invalid payload informed. " \
        "Unable to extract 'command' from ('#{@command}') " \
        "or 'arguments' (from '#{@arguments}')."
    end
  end
end

# EOF
