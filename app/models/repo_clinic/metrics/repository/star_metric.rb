module RepoClinic
  class Metrics::Repository::StarMetric < RepoClinic::Metric
    def self.name
      'GitHub Stars'
    end

    def read(source)
      source.repository[:stargazers_count]
    end
  end
end
