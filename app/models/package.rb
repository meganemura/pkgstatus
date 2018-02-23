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
    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      registry_metrics + repository_metrics
    end
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
  end

  def cache_key
    [self.class.name, registry, name].join(':')
  end
end
