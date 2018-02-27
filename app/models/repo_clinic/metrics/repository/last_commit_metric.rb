module RepoClinic
  class Metrics::Repository::LastCommitMetric < RepoClinic::Metric
    def self.title
      'Last commit'
    end

    def read(source)
      source.last_commit&.dig(:commit, :committer, :date)
    end

    def status
      return :success if elapsed_days < 30
      return :warning if elapsed_days < 90
      :danger
    end

    def elapsed_days
      (Time.zone.now - value) / 86400
    end
  end
end
