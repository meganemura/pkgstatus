class Project
  def self.find(id)
    new
  end

  # FIXME: Dummy
  def packages
    [
      %w(rubygems codestatus),
      %w(npm react),
    ].map { |registry, name| Package.find_by(registry: registry, name: name) }
  end
end
