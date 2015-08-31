require 'spec_helper'


module TestGoDutchReactor
  include GoDutch::Reactor
  extend self

  @@buffer ||= ''

  def send_data data
    @@buffer << data
    data
  end

  def buffer data=nil
    unless data.nil?
      @@buffer = data
    else
      return @@buffer
    end
  end

  def close_connection_after_writing
    return
  end

  def check_test_reactor
    critical "I have a critical."
    success "Somehow I called a bogus method."

    return "Something magick happens..."
  end
end

describe TestGoDutchReactor do
  after :each do
    TestGoDutchReactor::buffer('')
  end

  describe '#receive_data' do
    it 'should fail when receiving non-JSON data' do
      expect {
        TestGoDutchReactor::receive_data('trash')
      }.to raise_error(RuntimeError)
    end
  end

  describe '#check_test' do
    it 'should be able to call a method on test module' do
      TestGoDutchReactor::receive_data(
        { 'command' => 'check_test_reactor',
          'arguments' => []
        }.to_json
      )
      expect(TestGoDutchReactor::buffer.strip).to(
        eq(
          { 'check_name' => 'check_test_reactor',
            'check_status' => 2,
            'output' => 'I have a critical.',
            'stdout' => 'Something magick happens...',
          }.to_json
        )
      )
    end
  end
end

# EOF
