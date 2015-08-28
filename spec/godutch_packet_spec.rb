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
  end
end

# EOF
