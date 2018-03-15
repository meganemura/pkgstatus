class CreateProjectPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :project_packages, id: :uuid do |t|
      t.belongs_to :project, foreign_key: true, type: :uuid
      t.belongs_to :package, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
