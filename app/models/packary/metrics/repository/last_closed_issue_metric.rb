module Packary
  class Metrics::Repository::LastClosedIssueMetric < Packary::Metric
    def self.title
      'Last Closed Issue'
    end

    def read(source)
      source.last_closed_issue&.dig(:closed_at)
    end

    def status
      return :success if elapsed_days < 90
      return :warning if elapsed_days < 180
      :danger
    end

    def elapsed_days
      (Time.zone.now - value) / 86400
    end
  end
end
