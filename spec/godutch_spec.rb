require 'spec_helper'

module TestGoDutch
  include GoDutch::Reactor
  extend self

  def check_test
    success("Everything is o'right.")
    metric({ 'okay' => 1 })
    return 'check_test output'
  end

  def dummy_method
    puts 'I should never be called.'
  end

  def check_second_test
    puts 'Foo'
  end
end


describe GoDutch do
  describe '#receive_line' do
    it 'should fail when dummy packet is informed' do
      dummy_error = {
        'name' => nil,
        'status' => GoDutch::Status::UNKNOWN,
        'error' => "Error on parsing JSON: '757: unexpected token at 'dummy''",
      }.to_json

      expect { TestGoDutch::receive_line('dummy') }.to(
        output("#{dummy_error}\n").to_stderr
      )
    end

    it 'should be able to list check methos' do
      input = {
        'command' => '__list_check_methods',
        'arguments' => [],
      }.to_json

      output = {
        'name' => '__list_check_methods',
        'stdout' =>  ['check_test', 'check_second_test'],
      }.to_json

      expect { TestGoDutch::receive_line("#{input}\n") }.to(
        output("#{output}\n").to_stdout
      )
    end

    it 'should be able to call a check via this interface' do
      input = {
        'command' => 'check_test',
        'arguments' => [],
      }.to_json

      output = {
        'name' => 'check_test',
        'status' => GoDutch::Status::SUCCESS,
        'output' => "Everything is o'right.",
        'metrics' => [ { 'okay' => 1 }, ],
        'stdout' => 'check_test output'
      }.to_json

      expect { TestGoDutch::receive_line("#{input}\n") }.to(
        output("#{output}\n").to_stdout
      )
    end
  end
end

# EOF
