# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# CONFIGURATION
gem 'figaro', '~> 1.2'
gem 'rake', '~> 13.0'

# PRESENTATION LAYER
gem 'slim', '~> 4.1'

# APPLICATION LAYER
# Web application related
gem 'puma', '~> 6.0'
gem 'rack-session', '~> 0.3'
gem 'roda', '~> 3.62'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# Representers
gem 'multi_json', '~> 1.15'
gem 'roar', '~>1.1'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5'

# TESTING
group :test do
  gem 'minitest', '~> 5'
  gem 'minitest-rg', '~> 5'
  gem 'simplecov', '~> 0'

  gem 'headless', '~> 2.3'
  gem 'page-object', '~> 2.3'
  gem 'watir', '~> 7.0'
  gem 'webdrivers', '~> 5.0'
end

group :development do
  gem 'rerun', '~> 0'
end

# DEBUGGING
gem 'pry'

# QUALITY
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end
