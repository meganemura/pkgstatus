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
      return '> 99' if original_value.to_i > 99
      original_value.to_i
    end

    def status
      :info
    end
  end
end
