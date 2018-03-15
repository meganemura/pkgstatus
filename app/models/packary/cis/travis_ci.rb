module Packary
  module Cis
    class TravisCi
      def initialize(slug, default_branch)
        @slug = slug
        @default_branch = default_branch
      end

      attr_reader :slug, :default_branch

      def load_resource
        last_build
      end

      def self.metric_classes
        [
        ]
      end

      def metrics
        self.class.metric_classes.map { |klass| klass.new.preload(self) }
      end

      def resource
        @resource ||= {}
      end
      attr_writer :resource

      def html_url
        "https://travis-ci.org/#{slug}" if active?
      end

      # FIXME: Ruby specific
      def configured_versions
        last_build&.dig('config', 'rvm') || []
      end

      def last_build
        resource[:last_build] ||= begin
                                    repository&.branch(default_branch)&.to_h
                                  rescue ::Travis::Client::NotFound
                                    nil
                                  end
      end

      def repository
        client.repo(slug).tap do |repo|
          resource[:active] ||= repo.active?
        end
      rescue ::Travis::Client::NotFound
        nil
      end

      def active?
        # load repository
        repository unless resource.key?(:active)

        resource[:active]
      end

      def client
        @client ||= ::Travis::Client.new
      end
    end
  end
end
