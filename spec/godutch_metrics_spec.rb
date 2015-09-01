require 'spec_helper'


describe GoDutch::Metrics do
  describe '#metric' do
    it 'should be able to send a metric to buffer' do
      expect(GoDutch::Metrics::metric({ 'test' => 1 })).to be_truthy
    end
  end

  describe '#read_metrics_buffer' do
    it 'should be able to accumulate metrics on buffer' do
      expect(GoDutch::Metrics::read_metrics_buffer()).to eq([{ 'test' => 1 }])
    end
  end

  describe '#reset_metrics_buffer' do
    it 'should be able to reset metrics buffer' do
      expect(GoDutch::Metrics::read_metrics_buffer()).to eq([{ 'test' => 1 }])
      expect(GoDutch::Metrics::reset_metrics_buffer()).to be_truthy
      expect(GoDutch::Metrics::read_metrics_buffer()).to eq([])
    end
  end

  describe 'real use case' do
    include GoDutch::Metrics

    it 'should be able to accumulate and reset metrics' do
      expect(reset_metrics_buffer()).to be_truthy
      expect(metric({ 'one' => 1, 'two' => 2 })).to be_truthy
      expect(metric({ 'tree' => 3, 'four' => 4 })).to be_truthy
      expect(read_metrics_buffer()).to eq(
        [ { 'one' => 1, 'two' => 2 },
          { 'tree' => 3, 'four' => 4 },
        ]
      )
    end
  end

end

# EOF
