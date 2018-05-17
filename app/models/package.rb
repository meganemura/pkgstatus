class Package < ApplicationRecord
  has_many :project_packages
  has_many :projects, through: :project_packages
  has_many :metrics
  has_one :package_source

  # https://github.com/rubygems/rubygems.org/blob/master/lib/patterns.rb
  RUBYGEMS_SPECIAL_CHARACTERS = ".-_".freeze
  RUBYGEMS_ALLOWED_CHARACTERS = "[A-Za-z0-9#{Regexp.escape(RUBYGEMS_SPECIAL_CHARACTERS)}]+".freeze
  RUBYGEMS_NAME_PATTERN       = /\A#{RUBYGEMS_ALLOWED_CHARACTERS}\Z/

  NPM_DISALLOWED_CHARACTERS = /~()'!*/

  validates :registry, presence: true
  validates :name, presence: true
  validate :package_naming

  def package_naming
    if rubygem?
      rubygem_naming
    elsif npm?
      npm_naming
    end
  end

  def rubygem_naming
    return if name.match?(RUBYGEMS_NAME_PATTERN)
    errors.add(:name, 'Given name is not allowed.')
  end

  def rubygem?
    registry == 'rubygems'
  end

  # https://github.com/npm/validate-npm-package-name#naming-rules
  def npm_naming
    if name.length == 0 ||
       name.length > 214 ||
       name.strip != name ||
       name.match(/^\./) ||
       name.match(/^_/) ||
       name.match(NPM_DISALLOWED_CHARACTERS)
      errors.add(:name, 'Given name is not allowed.')
    end
  end

  def npm?
    registry == 'npm'
  end

  def cached?
    # TODO: Add expiration condition
    metrics.present?
  end

  def cache_later
    store_metrics_later if !package_source || package_source.expired?
  end

  def store_metrics_later
    FetchMetricsWorker.perform_async(registry, name)
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

  def repository_url
    package_source&.repository_url
  end

  def registry_url
    package_source&.registry_url
  end

  def ci_url
    package_source&.ci_url
  end

end
