class Metric < ApplicationRecord
  belongs_to :package

  # class name
  def type
    "Packary::Metrics::RegistryPackage::DownloadsMetric"
  end

  def value
    33256948
  end

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
    type.constantize
  end
end
