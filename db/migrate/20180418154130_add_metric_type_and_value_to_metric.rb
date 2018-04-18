class AddMetricTypeAndValueToMetric < ActiveRecord::Migration[5.2]
  def change
    add_column :metrics, :metric_type, :string
    add_column :metrics, :value, :string
  end
end
