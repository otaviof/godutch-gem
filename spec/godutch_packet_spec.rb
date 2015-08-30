require 'spec_helper'


describe GoDutch::Packet do
  before :all do
    @check_name = 'check_something'
    @packet = GoDutch::Packet.new(
      { 'command' => @check_name,
        'arguments' => [],
      }.to_json
    )
  end

  describe '#new' do
    it 'takes one optional argument to create a new Packet' do
      @packet.should be_an_instance_of GoDutch::Packet
    end

    it 'should be able to parse informed payload' do
      expect(@packet.command).to eq(@check_name)
      expect(@packet.arguments).to eq([])
    end

    it 'should be able to receive command arguments' do
      arguments = ['args', 'listed', 'on', 'array', 1, 1, 3, 2]
      packet = GoDutch::Packet.new(
        { 'command' => 'command',
          'arguments' => arguments,
        }.to_json
      )
      expect(packet.arguments).to eq(arguments)
    end

    it 'should fail when a incomplete packate is informed' do
      expect {
        GoDutch::Packet.new({ 'dummy' => 'packet' }.to_json)
      }.to raise_error(RuntimeError)
    end
  end
end

# EOF
