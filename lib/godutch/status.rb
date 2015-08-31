module GoDutch
  # Represents a given check returned status, it also buffers when sequential
  # checks are called, keeping the highest status only.
  module Status
    extend self

    SUCCESS = 0
    WARNING = 1
    CRITICAL = 2
    UNKNOWN = 3

    @@status_buffer = {}

    # Wipe out status buffer.
    def reset_status_buffer
      @@status_buffer = {}
    end

    # Returns status buffer
    def read_status_buffer
      return @@status_buffer
    end

    # Saves the latest status on buffer, based on it's state levels (see
    # constants on this module) keeping the highest saved.
    #   +status+  Integer, based on status constants;
    #   +message+ String or default nil;
    def __report(status, message=nil)
      # in case we already have a status being store, and thus the decision
      # method will be based on the highest status
      unless @@status_buffer.empty?
        if @@status_buffer['check_status'] > status
          return true
        end
      end

      @@status_buffer = {
        'check_status' => status,
        'output' => message,
      }
    end

    # Methods to represent the status returned by a given check, the only
    # input is a string with message to ilustrate the status.
    #   +message+   status message (String) or nil as default;
    def critical(message=nil)
      __report(CRITICAL, message)
    end

    def warning(message=nil)
      __report(WARNING, message)
    end

    def success(message=nil)
      __report(SUCCESS, message)
    end

    def unknown(message=nil)
      __report(UNKNOWN, message)
    end
  end
end

# EOF
