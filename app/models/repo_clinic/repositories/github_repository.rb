module RepoClinic
  class Repositories::GithubRepository < RepoClinic::Repository
    def self.metric_classes
      [
        RepoClinic::Metrics::Repository::StarMetric,
        RepoClinic::Metrics::Repository::LastCommitMetric,
        RepoClinic::Metrics::Repository::StatusMetric,
      ]
    end

    def repository
      resource[:repository] ||= begin
                                  # Sawyer::Resource -> Hash
                                  client.repository(slug).to_hash
                                rescue Octokit::NotFound
                                  nil
                                end
    end

    def last_commit
      resource[:last_commit] ||= begin
                                   client.commits(slug, per_page: 1).first.to_hash
                                 rescue Octokit::NotFound
                                   nil
                                 end
    end

    def status
      resource[:status] ||= client.combined_status(slug, default_branch)&.state
    rescue Octokit::NotFound
      nil
    end

    def html_url
      repository&.dig(:html_url)
    end

    private

    def default_branch
      repository&.dig(:default_branch)
    end

    def client
      @client ||= Octokit::Client.new(access_token: access_token)
    end

    def access_token
      ENV['REPOCLINIC_GITHUB_TOKEN']
    end
  end
end
