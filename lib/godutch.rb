require 'godutch/version'
require 'godutch/reactor'
require 'eventmachine'

module GoDutch
  # Runs the reactor through 'eventmachine'.
  #   +reactor+   Reactor module, that extends GoDutch::Reactor;
  def self.run(reactor)
    $stdout.sync = true

    EM.run do
      ['EXIT', 'SIGCHLD', 'SIGUSR1'].each do |signal|
        Signal.trap(signal) { EM.stop_event_loop }
      end

      # staring event machine to capture events on STDIN
      EM.attach($stdin, reactor)
    end
  end
end

# EOF
