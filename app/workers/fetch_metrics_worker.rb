class FetchMetricsWorker < ApplicationWorker
  def perform(registry, name)
    # XXX: Do not raise errors because it cause exceeding of sentry quota...
    return if rate_limited?

    package = Package.find_by(registry: registry, name: name)
    package.cache
  rescue Octokit::TooManyRequests => e
    self.rate_limit_reset = e.response_headers['x-ratelimit-reset'].to_i
  end

  def rate_limit_reset=(reset_time)
    reset_in = [reset_time - Time.now.to_i, 300].max
    Rails.cache.write(cache_key, reset_time, expires_in: reset_in)
  end

  def rate_limited?
    Rails.cache.exist?(cache_key)
  end

  def cache_key
    [self.class.name, 'rate_limit_reset'].join(':')
  end
end
