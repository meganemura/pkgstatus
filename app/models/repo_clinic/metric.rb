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

    # FIXME
    def status
      :warning
    end

    def class_name
      :warning
    end
  end
end
