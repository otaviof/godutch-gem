require 'godutch/version'
require 'godutch/reactor'
require 'eventmachine'
require 'pathname'

# Wrapping module, to hold primary event loop.
module GoDutch
  # Runs the reactor through 'eventmachine'.
  #   +reactor+   Reactor module, that extends GoDutch::Reactor;
  def self.run(reactor)
    EM.run do
      %w(EXIT SIGCHLD SIGUSR1).each do |signal|
        Signal.trap(signal) { EM.stop_event_loop }
      end

      unless ENV.key?('GODUTCH_SOCKET_PATH')
        fail "Can't find ENV['GODUTCH_SOCKET_PATH'], not able to speak."
      end

      File.umask(0000)
      socket_file = Pathname.new(ENV['GODUTCH_SOCKET_PATH'])
      File.unlink(socket_file) if File.exist?(socket_file)

      # starting event machine to listen to events on socket file
      EM.next_tick { EM.start_unix_domain_server(socket_file.to_s, reactor) }
    end
  end
end

# EOF
