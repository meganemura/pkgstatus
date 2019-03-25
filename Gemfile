source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

if v = ENV['CUSTOM_RUBY_VERSION']
  ruby v
end

gem 'rails', '~> 5.2.2'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'redis-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'rest-client'
gem 'sidekiq'
gem 'travis'
gem 'sentry-raven'
gem 'meta-tags'
gem 'kaminari'

# These will be removed
gem 'octokit'    # RepoClinic::Repositories::GithubRepository
gem 'gems'       # RepoClinic::RegistryPackages::RubygemsPackage
gem 'codestatus' # RepoClinic::Repository

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.7'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  gem 'derailed_benchmarks'
  gem 'stackprof'
  gem 'pp_sql'
  gem 'rails-erd'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.4'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'simplecov', require: false
  gem 'codecov', require: false
end
