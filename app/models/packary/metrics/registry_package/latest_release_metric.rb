module Packary
  class Metrics::RegistryPackage::LatestReleaseMetric < Packary::Metric
    def self.group
      :registry
    end

    def self.title
      'Latest Releases'
    end

    def read(source)
      Time.parse(source.gem_versions.first['built_at'])
    end

    def status
      return :success if value > 180.days.ago
      :warning
    end
  end
end
