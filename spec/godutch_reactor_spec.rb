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
    metric({ 'metric1' => 1 })
    critical('I have a critical.')
    success('Somehow I called a bogus method.')
    metric({ 'metric2' => 2 })

    return "Something magick happens..."
  end
end

describe TestGoDutchReactor do
  after :each do
    TestGoDutchReactor::buffer('')
  end

  describe '#receive_line' do
    it 'should fail when receiving non-JSON data' do
      # JSON returns a different error code on Windows, so simulating this
      # exception and saving to create the expected output
      json_error = nil
      begin
        JSON.parse('dummy')
      rescue JSON::ParserError => e
        json_error = e
      end

      output = {
        'name' => nil,
        'status' => GoDutch::Status::UNKNOWN,
        'error' => "Error on parsing JSON: '#{json_error}'",
      }.to_json

      expect { TestGoDutchReactor::receive_line('dummy') }.to(
        output("#{output}\n").to_stderr
      )
    end
  end

  describe '#check_test' do
    it 'should be able to call a method on test module' do
      input = {
        'command' => 'check_test_reactor',
        'arguments' => []
      }.to_json

      output = {
        'name' => 'check_test_reactor',
        'status' => GoDutch::Status::CRITICAL,
        'output' => 'I have a critical.',
        'metrics' => [ { 'metric1' => 1 }, { 'metric2' => 2 }, ],
        'stdout' => 'Something magick happens...',
      }.to_json

      expect { TestGoDutchReactor::receive_line("#{input}\n") }.to(
        output("#{output}\n").to_stdout
      )
    end
  end

  describe '#check_bogus' do
    it 'should report failure when calling a bogus check' do
      input = {
        'command' => 'check_bogus',
        'arguments' => [],
      }.to_json

      output = {
        'name' => 'check_bogus',
        'status' => GoDutch::Status::UNKNOWN,
        'error' => "[ERROR] Invalid command: 'check_bogus'",
      }.to_json

      expect { TestGoDutchReactor::receive_line(input) }.to(
        output("#{output}\n").to_stderr
      )
    end
  end
end

# EOF
