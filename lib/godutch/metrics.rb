module GoDutch
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

    def metric(data={})
      if @@metrics_buffer.empty?
        @@metrics_buffer = [data]
      else
        @@metrics_buffer << data
      end
    end
  end
end
