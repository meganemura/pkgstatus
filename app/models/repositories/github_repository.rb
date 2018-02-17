class Repositories::GithubRepository < ::Repository
  def self.metric_classes
    [
      Metrics::Repository::StarMetric,
    ]
  end
end
