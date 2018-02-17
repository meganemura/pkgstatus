module Repocheck
class Metrics::Repository::StarMetric < Repocheck::Metric
  def self.name
    'GitHub Stars'
  end

  def value
    source.repository[:stargazers_count]
  end
end
end
