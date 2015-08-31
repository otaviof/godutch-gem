require 'spec_helper'

module TestGoDutch
  include GoDutch::Reactor

  def check_test
    success "Everything is o'right."
    return 'check_test output'
  end
end


describe GoDutch do
  before :all do
    @socket_path = '/tmp/rspec-godutch.sock'
    @pid = fork do
      ['SIGUSR1', 'EXIT', 'SIGCHLD'].each do |signal|
        Signal.trap(signal) { exit! }
      end

      puts "*** Running GoDutch on PID #{$$} ***"
      ENV['GODUTCH_SOCKET_PATH'] = @socket_path
      GoDutch::run(TestGoDutch)
    end
    Process.detach(@pid)
    sleep 1
  end

  after :all do
    puts "After all, killing PID '#{@pid}'."
    Process.kill('SIGUSR1', @pid) rescue Exception
  end

  describe '#run' do
    it 'should have received the socket path from environment' do
      # have received the socket means that event-machine is already handling
      # it, so it can be found on the file-system
      File.exists?(@socket_path).should be_truthy
    end
  end

  describe '#check_test' do
    it 'should be able to receive data on socket' do
      socket = UNIXSocket.new(@socket_path)
      socket.write(
        { 'command' => 'check_test',
          'arguments' => [],
        }.to_json
      ).should be_truthy
      socket.flush().should be_truthy
      expect(socket.readline.strip).to(
        eq(
          { 'check_name' => 'check_test',
            'check_status' => 0,
            'output' => "Everything is o'right.",
            'stdout' => 'check_test output'
          }.to_json
        )
      )
      socket.close()
    end
  end
end

# EOF
