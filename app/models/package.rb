class Package
  attr_accessor :registry, :name

  # XXX
  def self.find_by(registry:, name:)
    new.tap do |pkg|
      pkg.registry = registry
      pkg.name = name
    end
  end

  def metrics
    cached = Rails.cache.read(cache_key)
    return cached if cached

    FetchMetricsWorker.perform_async(registry, name)

    []
  end

  def cache_metrics
    return if Rails.cache.exist?(cache_key)

    metrics = registry_metrics + repository_metrics
    Rails.cache.write(cache_key, metrics, expires_in: 12.hours)
  end

  def registry_metrics
    registry_package.metrics
  end

  def repository_metrics
    repository&.metrics || []
  end

  private

  def registry_package
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

    klass.new(name) if klass
  end

  def repository
    RepoClinic::Repository.from_package(registry, name)
  rescue
    nil
  end

  def cache_key
    [self.class.name, registry, name].join(':')
  end
end
