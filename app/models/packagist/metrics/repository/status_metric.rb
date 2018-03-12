module RepoClinic
  class Metrics::Repository::StatusMetric < RepoClinic::Metric
    def self.title
      'CI Status'
    end

    def read(source)
      source.status
    end

    def status
      case value
      when 'pending'
        :warning
      when 'success'
        :success
      when 'failure'
        :danger
      end
    end
  end
end
