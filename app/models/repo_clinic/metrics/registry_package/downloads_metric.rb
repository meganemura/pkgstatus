module RepoClinic
  class Metrics::RegistryPackage::DownloadsMetric < RepoClinic::Metric
    def self.title
      'Downloads'
    end

    def read(source)
      source.downloads
    end
  end
end
