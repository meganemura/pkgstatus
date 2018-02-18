module RepoClinic
  class Metric
    attr_reader :value

    def preload(source)
      @value = read(source)
      self
    end

    def self.name
    end

    def name
      self.class.name
    end
  end
end
