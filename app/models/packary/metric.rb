module Packary
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

    private

    # Use this if override value
    def original_value
      @value
    end
  end
end
