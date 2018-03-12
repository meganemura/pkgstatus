module Packagist
  class Metrics::RegistryPackage::ReleasesMetric < Packagist::Metric
    def self.title
      'Releases'
    end

    def read(source)
      source.gem_versions.size
    end

    def status
      :info
    end
  end
end
