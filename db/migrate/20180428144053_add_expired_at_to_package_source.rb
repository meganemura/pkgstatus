class AddExpiredAtToPackageSource < ActiveRecord::Migration[5.2]
  def change
    add_column :package_sources, :expired_at, :datetime
  end
end
