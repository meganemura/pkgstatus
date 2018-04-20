module Packary
  class Metrics::Repository::StarMetric < Packary::Metric
    def self.group
      :repository
    end

    def self.title
      'GitHub Stars'
    end

    def read(source)
      source.repository&.dig(:stargazers_count)
    end

    # Use ActiveModel::Attribute?
    def value
      original_value.to_i
    end

    def status
      return :success if value > 1_000
      return :warning if value > 50
      :danger
    end
  end
end
