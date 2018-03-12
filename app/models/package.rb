class Package
  attr_accessor :registry, :name

  # XXX
  def self.find_by(registry:, name:)
    new.tap do |pkg|
      pkg.registry = registry
      pkg.name = name
    end
  end

  attr_writer :resources
  def resources
    @resources ||= cached_resources || {}
  end

  def cached_resources
    Rails.cache.read(cache_key)
  end
  alias_method :cached, :cached_resources  # TODO: Deprecated

  def cached?
    Rails.cache.exist?(cache_key)
  end

  def cache_later
    return if cached?
    FetchMetricsWorker.perform_async(registry, name)
  end

  def cache
    return cached_resources if cached?

    metrics

    data = {
      repository_url: repository_url,
      registry: registry_package.resource,
      repository: repository.resource,
    }

    Rails.cache.write(cache_key, data, expires_in: cache_ttl)
  end

  def cache_ttl
    return rand(10..60).minutes if Rails.env.development?

    12.hours
  end

  def self.metric_classes
    registry_metric_classes + repository_metric_classes
  end

  def self.registry_metric_classes
    RepoClinic::RegistryPackages::RubygemsPackage.metric_classes
  end

  def self.repository_metric_classes
    RepoClinic::Repositories::GithubRepository.metric_classes
  end

  def metric_collection
    metrics.each_with_object({}) do |metric, hash|
      hash[metric.class.to_s] = metric
    end
  end

  def metrics
    registry_metrics + repository_metrics
  end

  def registry_metrics
    registry_package.metrics
  end

  def repository_metrics
    repository&.metrics || []
  end

  def repository_url
    repository&.html_url
  end

  def registry_url
    registry_package.html_url
  end

  private

  def registry_package
    return @registry_package if defined?(@registry_package)

    # XXX: Where to separate registries
    # TODO: Detect registry_package class
    klass = case registry.to_s
            when 'rubygems'
              RepoClinic::RegistryPackages::RubygemsPackage
            when 'npm'
              RepoClinic::RegistryPackages::NpmPackage
            else
              nil
            end

    return unless klass

    @registry_package = klass.new(name).tap do |pkg|
      pkg.resource = resources[:registry]
    end
  end

  def repository
    @repository ||= RepoClinic::Repository.from_package(registry, name).tap do |repo|
      repo.resource = resources[:repository]
    end
  rescue
    nil
  end

  def cache_key
    [self.class.name, registry, name].join(':')
  end
end
