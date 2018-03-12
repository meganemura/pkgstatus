module Packary
  class Repositories::GithubRepository < Packary::Repository
    def self.metric_classes
      [
        Packary::Metrics::Repository::StarMetric,
        Packary::Metrics::Repository::LastCommitMetric,
        Packary::Metrics::Repository::StatusMetric,
        Packary::Metrics::Repository::ContributorsMetric,
        Packary::Metrics::Repository::LastClosedIssueMetric,
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
      combined_status&.dig(:state)
    end

    def combined_status
      resource[:combined_status] ||= client.combined_status(slug, default_branch).to_hash
    rescue Octokit::NotFound
      nil
    end

    def contributors
      resource[:contributors] ||= client.contributors(slug)
    end

    def last_closed_issue
      closed_issues.first
    end

    def closed_issues
      resource[:closed_issues] ||= client.issues(slug, state: 'closed', per_page: 50).map(&:to_h)
    end

    def html_url
      repository&.dig(:html_url)
    end

    private

    def default_branch
      repository&.dig(:default_branch)
    end

    def client
      @client ||= Octokit::Client.new(access_token: access_token, per_page: 100).tap do
        puts "client: #{slug}" if Rails.env.development?
      end
    end

    def access_token
      ENV['REPOCLINIC_GITHUB_TOKEN']
    end
  end
end
