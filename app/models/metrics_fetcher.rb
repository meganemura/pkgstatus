class MetricsFetcher
  def initialize(package_id)
    @package = Package.find(package_id)
  end

  attr_reader :package

  def fetch
    if package_source
      return unless package_source.expired?
    end

    store_metrics
    update_package_source
  end

  attr_writer :resources
  def resources
    @resources ||= {}
  end

  def store_metrics
    # FIXME: Implement #cache to registry_package, repository
    fetch_metrics.each do |metric|
      mtr = Metric.find_or_initialize_by(package_id: id, metric_type: metric.class.name)
      mtr.value = metric.value.to_s
      mtr.save!
    end
  end

  def update_package_source
    package_source.update!(repository_url: fetch_repository_url,
                           registry_url: fetch_registry_url,
                           ci_url: fetch_ci_url,
                           expired_at: Time.current + PackageSource.ttl)
  end

  def package_source
    @package_source ||= PackageSource.find_or_initialize_by(package_id: id)
  end

  def fetch_metrics
    registry_metrics + repository_metrics
  end

  def registry_metrics
    registry_package.metrics
  end

  def repository_metrics
    repository&.metrics || []
  end

  private

  def registry_package
    return @registry_package if @registry_package

    # XXX: Where to separate registries
    # TODO: Detect registry_package class
    klass = case registry.to_s
            when 'rubygems'
              Packary::RegistryPackages::RubygemsPackage
            when 'npm'
              Packary::RegistryPackages::NpmPackage
            else
              nil
            end

    return unless klass

    @registry_package = klass.new(name).tap do |pkg|
      pkg.resource = resources[:registry]
    end
  end

  def repository
    @repository ||= Packary::Repository.from_package(registry, name).tap do |repo|
      repo.resource = resources[:repository]
    end
  rescue
    nil
  end

  def ci
    return nil unless repository

    @ci ||= Packary::Cis::TravisCi.new(repository.slug, repository.default_branch).tap do |c|
      c.resource = resources[:ci]
    end
  end

  def fetch_repository_url
    repository&.html_url
  end

  def fetch_registry_url
    registry_package.html_url
  end

  def fetch_ci_url
    ci&.html_url
  end

  def id
    package.id
  end

  def name
    package.name
  end

  def registry
    package.registry
  end
end
