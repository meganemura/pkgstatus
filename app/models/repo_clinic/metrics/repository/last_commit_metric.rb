module RepoClinic
  class Metrics::Repository::LastCommitMetric < RepoClinic::Metric
    def self.name
      'Last commit'
    end

    def value
      source.last_commit.dig(:commit, :committer, :date)
    end
  end
end
