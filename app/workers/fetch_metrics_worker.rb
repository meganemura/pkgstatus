class FetchMetricsWorker < ApplicationWorker
  def perform(registry, name)
    package = Package.find_by(registry: registry, name: name)
    package.cache
  end
end