module Packary
  class Metrics::RegistryPackage::LatestReleaseMetric < Packary::Metric
    def self.group
      :registry
    end

    def self.title
      'Latest Releases'
    end

    def read(source)
      return nil unless source.gem_versions

      Time.parse(source.gem_versions.first['built_at'])
    end

    # Use ActiveModel::Attribute?
    def value
      Time.parse(original_value) if original_value.present?
    end

    def status
      return :warning unless value

      return :success if value > 180.days.ago
      :warning
    end
  end
end
