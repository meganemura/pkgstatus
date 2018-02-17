class Resolver
  def initialize(registry, name)
    @registry = registry
    @name = name
  end

  attr_reader :registry, :name

  # XXX: Use pkgns.org to resolve
  # FIXME: dummy repo url
  def resolve
    'https://github.com/meganemura/codestatus'
  end
end
