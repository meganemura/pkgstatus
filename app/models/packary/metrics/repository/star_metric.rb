module Packagist
  class Metrics::Repository::StarMetric < Packagist::Metric
    def self.title
      'GitHub Stars'
    end

    def read(source)
      source.repository&.dig(:stargazers_count)
    end

    def status
      return :success if value > 1_000
      return :warning if value > 50
      :danger
    end
  end
end