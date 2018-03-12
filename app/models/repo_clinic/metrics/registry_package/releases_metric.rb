module RepoClinic
  class Metrics::RegistryPackage::ReleasesMetric < RepoClinic::Metric
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
