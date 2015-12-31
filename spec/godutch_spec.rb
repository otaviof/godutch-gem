require 'spec_helper'

# Dummy module to test GoDutch Reactor.
module TestGoDutch
  include GoDutch::Reactor

  def check_test
    success("Everything is o'right.")
    metric('okay' => 1)
    'check_test output'
  end

  def dummy_method
    puts 'I should never be called.'
  end

  def check_second_test
    puts 'Foo'
  end
end

describe GoDutch do
  include RSpecEM::Client
  include RSpecEM::Server

  it 'should fail when dummy packet is informed' do
    spawn_reactor(TestGoDutch, "dummy\n") do |resp|
      expect(resp).to eq(
        'name' => nil,
        'status' => GoDutch::Status::UNKNOWN,
        'error' => "Error on parsing JSON: '#{json_exception('dummy')}'"
      )
    end
  end

  it 'should be able to list check methos' do
    input = { 'command' => '__list_check_methods', 'arguments' => [] }.to_json
    spawn_reactor(TestGoDutch, input + "\n") do |resp|
      expect(resp).to eq(
        'name' => '__list_check_methods',
        'stdout' =>  %w(check_test check_second_test)
      )
    end
  end

  it 'should be able to call a check via this interface' do
    input = { 'command' => 'check_test', 'arguments' => [] }.to_json
    spawn_reactor(TestGoDutch, input + "\n") do |resp|
      expect(resp).to eq(
        'name' => 'check_test',
        'status' => GoDutch::Status::SUCCESS,
        'metrics' => [{ 'okay' => 1 }],
        'stdout' => ["Everything is o'right.", 'check_test output']
      )
    end
  end
end

# EOF
