module Packagist
  class Metrics::RegistryPackage::DownloadsMetric < Packagist::Metric
    def self.title
      'Downloads'
    end

    def read(source)
      source.downloads
    end

    def status
      return :success if value > 1_000_000
      return :warning if value > 10_000
      :failure
    end
  end
end
