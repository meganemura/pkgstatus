class MetricsFetcher
  def initialize(package_id)
    @package = Package.find(package_id)
  end

  attr_reader :package

  def fetch
    package.cache
  end
end
