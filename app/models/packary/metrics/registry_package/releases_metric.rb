module Packary
  class Metrics::RegistryPackage::ReleasesMetric < Packary::Metric
    def self.group
      :registry
    end

    def self.title
      'Releases'
    end

    def read(source)
      source.gem_versions&.size
    end

    def status
      :info
    end
  end
end
