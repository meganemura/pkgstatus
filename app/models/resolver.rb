class Resolver
  def initialize(registry)
    @registry = registry
  end

  attr_reader :registry

  # XXX: Use pkgns.org to resolve
  # FIXME: dummy repo url
  def resolve
    'https://github.com/meganemura/codestatus'
  end
end
