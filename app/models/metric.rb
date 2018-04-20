class Metric < ApplicationRecord
  belongs_to :package

  def title
    klass.title
  end

  def class_name
    instance.class_name
  end

  private

  def instance
    klass.new(value: value)
  end

  def klass
    metric_type.constantize
  end
end
