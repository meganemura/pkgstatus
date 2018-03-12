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

    # TODO: Move into decorator
    def class_name
      status
    end
  end
end
