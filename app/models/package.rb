class Package
  attr_accessor :registry, :name

  # XXX
  def self.find_by(registry:, name:)
    new.tap do |pkg|
      pkg.registry = registry
      pkg.name = name
    end
  end

  def cached
    Rails.cache.read(cache_key)
  end

  def cached?
    Rails.cache.exist?(cache_key)
  end

  def cache_later
    return if cached?
    FetchMetricsWorker.perform_async(registry, name)
  end

  def cache
    return cached if cached?

    data = {
      repository_url: repository_url,
      metrics:  registry_metrics + repository_metrics,
    }

    Rails.cache.write(cache_key, data, expires_in: 12.hours)
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

  def registry_metrics
    registry_package.metrics
  end

  def repository_metrics
    repository&.metrics || []
  end

  def repository_url
    repository.html_url
  end

  def registry_url
    registry_package.html_url
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
