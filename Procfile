release: bundle exec rails db:migrate
web: bundle exec puma -R config.ru -C config/puma.rb -p $PORT
worker: bundle exec sidekiq -C config/sidekiq.yml
