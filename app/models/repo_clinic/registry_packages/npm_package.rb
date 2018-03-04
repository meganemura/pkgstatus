module RepoClinic
  module RegistryPackages
    class NpmPackage
      NPM_REGISTRY_ENDPOINT = 'https://registry.npmjs.org/'.freeze

      def initialize(name)
        @name = name
      end

      attr_reader :name

      def self.metric_classes
        [
          Metrics::RegistryPackage::DownloadsMetric,
        ]
      end

      def metrics
        self.class.metric_classes.map { |klass| klass.new.preload(self) }
      end

      def package_info
        @package_info ||= request(package_uri)
      end

      def request(uri)
        response = RestClient.get(uri)
        JSON.parse(response)
      rescue RestClient::NotFound
        nil
      end

      def package_uri
        File.join(NPM_REGISTRY_ENDPOINT, slash_escaped_package)
      end

      def html_url
        "https://www.npmjs.com/package/#{name}"
      end

      # for scoped package
      #   For example, to access @atlassian/aui information,
      #   we must use https://registry.npmjs.org/@atlassian%2Faui,
      #   not https://registry.npmjs.org/%40atlassian%2Faui.
      def slash_escaped_package
        name.gsub('/', CGI.escape('/'))
      end

      # https://github.com/npm/registry/blob/master/docs/download-counts.md
      # https://github.com/npm/download-counts/issues/1#issuecomment-293756533
      def downloads
        responses = (2015..Date.today.year).map do |year|
          uri = "https://api.npmjs.org/downloads/point/#{year}-01-01:#{year}-12-31/#{slash_escaped_package}"
          request(uri)
        end

        responses.inject(0) { |value, hash| value + hash['downloads'] }
      end
    end
  end
end
