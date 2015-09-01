module GoDutch
  # Encapsulates the metrics of any monitoring checks, since there's quite
  # some data we collect as a boilerplate to monitoring any application and
  # that's a low hanging fruit on re-using on a system like CollectD/Graphite.
  module Metrics
    extend self

    @@metrics_buffer = []

    # Wipe out metrics buffer.
    def reset_metrics_buffer
      @@metrics_buffer = []
    end

    # Returns metrics buffer
    def read_metrics_buffer
      return @@metrics_buffer
    end

    # Accumulate a metric on the buffer, each meatric is a hash stored on a
    # array of hashes (@@metrics_buffer).
    #   +data+  Hash format, keys and values representing a given measurement;
    def metric(data={})
      if @@metrics_buffer.empty?
        @@metrics_buffer = [data]
      else
        @@metrics_buffer << data
      end
    end
  end
end

# EOF
