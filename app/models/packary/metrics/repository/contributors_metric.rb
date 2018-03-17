module Packary
  class Metrics::Repository::ContributorsMetric < Packary::Metric
    def self.group
      :repository
    end

    def self.title
      'Contributors'
    end

    def read(source)
      source.contributors.size
    end

    def value
      return '> 99' if original_value > 99
      original_value
    end

    def status
      :info
    end
  end
end
