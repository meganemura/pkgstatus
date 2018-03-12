module RepoClinic
  class MetricSource
    def initialize
      @source = {}
    end

    def [](key)
      @source[key]
    end

    def []=(key, value)
      @source[key] = value
    end
  end
end
