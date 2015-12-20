require 'godutch/version'
require 'godutch/reactor'
require 'eventmachine'

# Wrapping module, to hold primary event loop.
module GoDutch
  # Runs the reactor through 'eventmachine'.
  #   +reactor+   Reactor module, that extends GoDutch::Reactor;
  def self.run(reactor)
    EM.run do
      %w(EXIT SIGCHLD SIGUSR1).each do |signal|
        Signal.trap(signal) { EM.stop_event_loop }
      end

      File.umask(0000)
      socket_file = '/tmp/ruby-starlite.sock'
      File.unlink(socket_file) if File.exist?(socket_file)

      # starting event machine to listen to events on socket file
      EM.start_unix_domain_server(socket_file, reactor)
    end
  end
end

# EOF
