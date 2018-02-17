class Metrics::Repository::LastCommitMetric < ::Metric
  def self.name
    'Last commit'
  end

  def value
    source.last_commit.dig(:commit, :committer, :date)
  end
end
