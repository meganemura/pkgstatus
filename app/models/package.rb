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
    registry_metrics + repository_metrics
  end

  def registry_metrics
    registry_package.metrics
  end

  def repository_metrics
    repository.metrics
  end

  private

  def registry_package
    # XXX: Where to separate registries
    # TODO: Detect registry_package class
    Repocheck::RegistryPackages::RubygemsPackage.new(name)
  end

  def repository
    Repocheck::Repository.from_package(registry, name)
  end

  def cache_key
    [self.class.name, registry, name].join(':')
  end
end
