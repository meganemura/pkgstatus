module RepoClinic
  class Metrics::RegistryPackage::DownloadsMetric < RepoClinic::Metric
    def self.title
      'Downloads'
    end

    def read(source)
      source.gem_info['downloads']
    end
  end
end
