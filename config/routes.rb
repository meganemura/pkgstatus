Rails.application.routes.draw do
  get 'top_pages/index'
  # Sidekiq
  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/projects/:id', to: 'projects#show'

  constraints = {
    registry: %r{(?!stylesheets|javascripts)[^/]*},
    package: /.*/,
  }
  get '/:registry/:package', to: 'packages#show', constraints: constraints
end
