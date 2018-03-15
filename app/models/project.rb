class Project
  def self.find(id)
    new
  end

  def packages
    x = sample_rubygems_packages.map { |x| ['rubygems', x] }
    y = sample_npm_packages.map { |x| ['npm', x] }

    if Rails.env.development? || ENV['PKGSTATUS_MIN_PACKAGES']
      x = x.first(6)
      y = y.first(3)
    end

    pkgs = x + y

    pkgs.map { |registry, name| Package.find_by(registry: registry, name: name) }
  end

  private

  def sample_rubygems_packages
    File.read(Rails.root.join('db', 'static', 'mastodon-rubygems.list')).lines.map(&:chomp)
  end

  def sample_npm_packages
    File.read(Rails.root.join('db', 'static', 'mastodon-npm.list')).lines.map(&:chomp)
  end
end
