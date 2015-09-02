require 'spec_helper'

include GoDutch::Helper


describe GoDutch::Helper do
  describe '#__list_helper_methods' do
    it 'should be able to look for helper methods' do
      # not based on environment variable this time
      expect(__list_helper_methods()).to(
        eq(['__list_helper_methods', '__list_check_methods'])
      )
    end
  end
  describe '#__list_check_methods' do
    it 'should be no checks declared' do
      # since there's no live GoDutch agent here
      expect(__list_check_methods().empty?).to be_truthy
    end
  end
end

# EOF
