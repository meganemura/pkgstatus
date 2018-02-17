module Repocheck
class Metrics::RegistryPackage::DownloadsMetric < Repocheck::Metric
  def self.name
    'Downloads'
  end

  def value
    source.gem_info['downloads']
  end
end
end
