Rails.application.routes.draw do
  constraints = {
    registry: %r{(?!stylesheets|javascripts)[^/]*},
    package: /.*/,
  }
  get '/:registry/:package', to: 'packages#show', constraints: constraints
end
