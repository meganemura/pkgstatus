class Package < ApplicationRecord
  has_many :project_packages
  has_many :projects, through: :project_packages
  has_many :metrics
  has_one :package_source

  # https://github.com/rubygems/rubygems.org/blob/master/lib/patterns.rb
  RUBYGEMS_SPECIAL_CHARACTERS = ".-_".freeze
  RUBYGEMS_ALLOWED_CHARACTERS = "[A-Za-z0-9#{Regexp.escape(RUBYGEMS_SPECIAL_CHARACTERS)}]+".freeze
  RUBYGEMS_NAME_PATTERN       = /\A#{RUBYGEMS_ALLOWED_CHARACTERS}\Z/

  validates :registry, presence: true
  validates :name, presence: true
  validate :rubygem_naming, if: :rubygem?

  def rubygem_naming
    return if name.match?(RUBYGEMS_NAME_PATTERN)
    errors.add(:name, 'Given name is not allowed.')
  end

  def rubygem?
    registry == 'rubygems'
  end

  attr_writer :resources
  def resources
    @resources ||= cached_resources || {}
  end

  def cached_resources
    Rails.cache.read(cache_key)
  end

  def cached?
    metrics.present?
  end

  def cache_later
    return if cached?
    FetchMetricsWorker.perform_async(registry, name)
  end

  def cache
    return cached_resources if cached?

    # FIXME: Implement #cache to registry_package, repository
    fetch_metrics

    ci&.load_resource

    data = {
      repository_url: repository_url,
      registry: registry_package.resource,
      repository: repository&.resource,
      ci: ci&.resource,
    }

    Rails.cache.write(cache_key, data, expires_in: cache_ttl)
  end

  def cache_ttl
    return rand(10..60).minutes if Rails.env.development?

    36.hours
  end

  def self.metric_classes
    registry_metric_classes + repository_metric_classes
  end

  def self.registry_metric_classes
    Packary::RegistryPackages::RubygemsPackage.metric_classes
  end

  def self.repository_metric_classes
    Packary::Repositories::GithubRepository.metric_classes
  end

  def metric_collection_old
    fetch_metrics.each_with_object({}) do |metric, hash|
      hash[metric.class.to_s] = metric
    end
  end

  def metric_collection
    metrics.each_with_object({}) do |metric, hash|
      hash[metric.type] = metric
    end
  end

  def fetch_metrics
    registry_metrics + repository_metrics
  end

  def registry_metrics
    Rails.cache.fetch(cache_key(__method__), expires_in: cache_ttl) do
      registry_package.metrics
    end
  end

  def repository_metrics
    Rails.cache.fetch(cache_key(__method__), expires_in: cache_ttl) do
      repository&.metrics || []
    end
  end

  def repository_url
    package_source&.repository_url
  end

  def registry_url
    package_source&.registry_url
  end

  def ci_url
    package_source&.ci_url
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

  def cache_key(key = nil)
    [self.class.name, registry, name, key].compact.join(':')
  end
end
