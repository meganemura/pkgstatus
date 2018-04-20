class CreatePackageSources < ActiveRecord::Migration[5.2]
  def change
    create_table :package_sources, id: :uuid do |t|
      t.belongs_to :package, foreign_key: true, type: :uuid
      t.string :repository_url
      t.string :registry_url
      t.string :ci_url

      t.timestamps
    end
  end
end
