require 'godutch/version'
require 'godutch/reactor'

module GoDutch
  @@socket_path = nil

  # Runs the reactor through 'eventmachine'.
  #   +reactor+   Reactor module, that extends GoDutch::Reactor;
  def self.run(reactor)
    set_socket_path()

    File.umask 0000
    File.unlink(@@socket_path) if File.exists?(@@socket_path)

    require 'eventmachine'
    EM.run do
      ['EXIT', 'SIGCHLD', 'SIGUSR1'].each do |signal|
        Signal.trap(signal) { EM.stop_event_loop }
      end
      EM.start_unix_domain_server(@@socket_path, reactor)
    end
  end

  # Imports the socket path from environment variables, if socket path is not
  # found, it will raise. The idea here is to make deployments easy on the fly
  # settings on communication with master daemon.
  def self.set_socket_path
    unless ENV.has_key?('GODUTCH_SOCKET_PATH')
      raise "Can't find ENV['GODUTCH_SOCKET_PATH'], hence no communication."
    end
    @@socket_path = ENV['GODUTCH_SOCKET_PATH']
  end
end

# EOF
