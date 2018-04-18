module Packary
  class Metrics::RegistryPackage::DownloadsMetric < Packary::Metric
    def self.group
      :registry
    end

    def self.title
      'Downloads'
    end

    def read(source)
      source.downloads
    end

    # Use ActiveModel::Attribute?
    def value
      original_value.to_i
    end

    def status
      return :warning unless value

      return :success if value > 1_000_000
      return :warning if value > 10_000
      :failure
    end
  end
end
