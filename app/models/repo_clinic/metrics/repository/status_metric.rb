module RepoClinic
  class Metrics::Repository::StatusMetric < RepoClinic::Metric
    def self.title
      'CI Status'
    end

    def read(source)
      source.status
    end
  end
end
