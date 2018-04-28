class PackageSource < ApplicationRecord
  belongs_to :package

  def expired?
    return true unless expired_at

    expired_at < Time.current
  end

  def self.ttl
    7.days
  end
end
