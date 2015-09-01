require 'spec_helper'


describe GoDutch::Status do
  describe '#warning' do
    it 'should be able to call warning status' do
      expect(GoDutch::Status::warning('warning')).to be_truthy
    end
  end

  describe '#critical' do
    it 'should be able to call warning status' do
      expect(GoDutch::Status::critical('critical')).to be_truthy
    end
  end

  describe '#success' do
    it 'should be able to call warning status' do
      expect(GoDutch::Status::success('success')).to be_truthy
    end
  end

  describe '#unknown' do
    it 'should be able to call warning status' do
      GoDutch::Status::unknown('unknown').should be_truthy
    end
  end

  describe 'keeping the highest alert' do
    include GoDutch::Status

    it 'should be able to reset status buffer' do
      read_status_buffer.empty?.should be false
      reset_status_buffer.should be_truthy
      read_status_buffer.empty?.should be true
    end

    it 'should be able to keep the highest alert on buffer' do
      unknown('unknown').should be_truthy
      success('success').should be_truthy
      warning('warning').should be_truthy

      expect(read_status_buffer()).to have_key('check_status')
      expect(read_status_buffer()).to have_key('output')
      expect(read_status_buffer['output']).to eq('unknown')
      expect(read_status_buffer['check_status']).to eq(
        GoDutch::Status::UNKNOWN
      )
    end
  end
end

# EOF
