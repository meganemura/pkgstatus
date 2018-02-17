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
    []
  end

  def repository_metrics
    []
  end
end
