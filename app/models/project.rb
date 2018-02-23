class Project
  def self.find(id)
    new
  end

  def packages
    pkgs = []
    pkgs += File.read(Rails.root.join('db', 'static', 'mastodon-rubygems.list')).lines.map { |x| ['rubygems', x.chomp] }
    pkgs += File.read(Rails.root.join('db', 'static', 'mastodon-npm.list')).lines.map { |x| ['npm', x.chomp] }

    pkgs.map { |registry, name| Package.find_by(registry: registry, name: name) }
  end
end
