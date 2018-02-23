module RepoClinic
  module RegistryPackages
    class RubygemsPackage
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

      def gem_info
        @info ||= begin
                    Gems.info(name)
                  rescue JSON::ParserError
                    # When the package is not found on rubygems,
                    # Gems does try to parse html as json and raise JSON::ParserError :sob:
                    nil
                  end
      end

      def downloads
        gem_info['downloads']
      end
    end
  end
end
