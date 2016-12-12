source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc

# Recommended for admin interface
# gem 'activeadmin', github: 'activeadmin' # There is no Rails 4 version just yet
# gem 'devise'

# Recommended to manage authorization
# gem 'pundit'

# Recommended to handle images
# gem 'paperclip'
# If paperclip stored on S3
# gem 'aws-sdk'

# Recommended for serializing models in json
# gem 'active_model_serializers', '~> 0.10.0.rc3'

group :development, :test do
  gem 'byebug'
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'stackprof'
  gem 'rubocop'
end

group :test do
  gem 'minitest-reporters'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
end

group :development do
  gem 'spring'
end

group :staging, :production do
  gem 'passenger'
  gem 'newrelic_rpm'
end

gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
