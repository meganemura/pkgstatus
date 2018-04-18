class CreateMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :metrics, id: :uuid do |t|
      t.belongs_to :package, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
