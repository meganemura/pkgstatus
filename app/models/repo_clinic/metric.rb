module RepoClinic
  class Metric
    def initialize(source)
      @source = source
    end

    attr_reader :source

    def self.name
    end

    def name
      self.class.name
    end
  end
end
