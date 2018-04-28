class PackageSource < ApplicationRecord
  belongs_to :package

  def expired?
    updated_at <= 7.days.ago
  end
end
