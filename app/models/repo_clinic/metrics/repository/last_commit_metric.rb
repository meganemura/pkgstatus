module RepoClinic
  class Metrics::Repository::LastCommitMetric < RepoClinic::Metric
    def self.title
      'Last commit'
    end

    def read(source)
      source.last_commit&.dig(:commit, :committer, :date)
    end
  end
end
