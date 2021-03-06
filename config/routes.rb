Rails.application.routes.draw do
  root 'top_pages#index'

  # Sidekiq
  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/projects/:id', to: 'projects#show', as: 'project'
  delete '/projects/:id', to: 'projects#destroy'
  post '/projects', to: 'projects#create'

  constraints = {
    registry: %r{(?!stylesheets|javascripts)[^/]*},
    package: /.*/,
  }
  get '/:registry/:package', to: 'packages#show', constraints: constraints
end
