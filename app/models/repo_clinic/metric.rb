module RepoClinic
  class Metric
    attr_reader :value

    def preload(source)
      @value = read(source)
      self
    end

    def self.title
    end

    def title
      self.class.title
    end
  end
end
