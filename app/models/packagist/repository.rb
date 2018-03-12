module Packagist
  class Repository
    # FIXME: Detect repository service from uri
    def self.from_package(registry, name)
      record = Resolver.new(registry, name).resolve
      Repositories::GithubRepository.new(record[:slug])
    end

    def initialize(slug)
      @slug = slug
    end

    attr_reader :slug

    def self.metric_classes
      []
    end

    def metrics
      self.class.metric_classes.map { |klass| klass.new.preload(self) }
    end

    def resource
      @resource ||= {}
    end
    attr_writer :resource

    class Resolver
      def initialize(registry, name)
        @registry = registry
        @name = name
      end

      attr_reader :registry, :name

      # XXX: Use pkgns.org to resolve
      def resolve
        resolved = Codestatus.resolver(registry).resolve!(name)
        host = if resolved.class == Codestatus::Repositories::GitHubRepository
                 :github
               else
                 nil
               end

        {
          host: host,
          slug: resolved.slug,
        }
      end
    end
  end
end
