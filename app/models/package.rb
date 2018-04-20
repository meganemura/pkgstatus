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
    @resources ||= {}
  end

  def cached?
    # TODO: Add expiration condition
    metrics.present?
  end

  def cache_later
    store_metrics_later
  end

  def store_metrics_later
    FetchMetricsWorker.perform_async(registry, name)
  end

  def cache
    store_metrics
  end

  def store_metrics
    # FIXME: Implement #cache to registry_package, repository
    fetch_metrics.each do |metric|
      mtr = metrics.find_or_initialize_by(package_id: id, metric_type: metric.class.name)
      mtr.value = metric.value.to_s
    end
    save!

    pkg_source = PackageSource.find_or_initialize_by(package_id: id)
    pkg_source.update!(repository_url: fetch_repository_url, registry_url: fetch_registry_url, ci_url: fetch_ci_url)
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

  def metric_collection
    metrics.each_with_object({}) do |metric, hash|
      hash[metric.metric_type] = metric
    end
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

  def fetch_repository_url
    repository&.html_url
  end

  def fetch_registry_url
    registry_package.html_url
  end

  def fetch_ci_url
    ci&.html_url
  end
end
