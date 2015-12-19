module GoDutch
  # Meant to hold methods that can only be called by GoDutch master daemon,
  # proving meta-data about which checks are present on the Reactor.
  module Helper
    @@checks_start_with = ENV['GODUTCH_CHECK_PREFIX'] || 'check_'
    @@helper_start_with = '__'

    # Looking for all Helper checks, which by convention start with attribute
    # 'helper_start_with' value. Returns a array of strings, method names.
    def __list_helper_methods
      # avoiding '__self__' and '__id__' symbols with last regex part
      methods.grep(/^#{@@helper_start_with}.*?[^__]$/) do |method|
        method.to_s
      end
    end

    # Look for method names that start with attribute 'checks_start_with'
    # value. Returns a array of strings.
    def __list_check_methods
      methods.grep(/^#{@@checks_start_with}/) do |method|
        method.to_s
      end
    end
  end
end

# EOF
