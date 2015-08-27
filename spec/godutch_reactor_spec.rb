require 'spec_helper'


module TestGoDutchReactor
  include GoDutch::Reactor

  def check_test
    puts "Something magick happens..."
    return true
  end
end

include TestGoDutchReactor


describe TestGoDutchReactor do
  describe '#receive_data' do
    it 'should be able to receive a JSON payload' do
      TestGoDutchReactor::receive_data(
        { 'command' => 'check_test' }.to_json
      ).should be_truthy
    end

    it 'should fail when receiving non-JSON data' do
      expect {
        TestGoDutchReactor::receive_data('trash')
      }.to raise_error(RuntimeError)
    end
  end

  describe '#check_test' do
    it 'should be able to call a method on test module' do
      TestGoDutchReactor::receive_data(
        { 'command' => 'check_test',
          'arguments' => []
        }.to_json
      ).should be_truthy
    end
  end
end

# EOF
