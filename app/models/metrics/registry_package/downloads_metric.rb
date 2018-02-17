class Metrics::RegistryPackage::DownloadsMetric < ::Metric
  def self.name
    'Downloads'
  end

  def value
    source.gem_info['downloads']
  end
end
