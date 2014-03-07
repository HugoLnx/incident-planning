source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use mysql as the database for Active Record
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'compass-rails', '~> 1.1.2'
group :assets do
  gem 'compass-colors'
end

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'devise', '~> 3.2.3'

# Use CoffeeScript for .js.coffee assets and views
#gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', "~> 2.2.0"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem "simple_form", "~> 3.0.1"

gem "interactive_editor"

group :production do
  gem 'rails_12factor'
  gem 'pg'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test, :development do
  gem 'rspec-rails', "~> 2.14.1"
  gem 'database_cleaner', "~> 1.2.0"
  gem 'factory_girl_rails', "~> 4.3.0"
  gem 'capybara', "~> 2.2.1"
  gem 'poltergeist', "~> 1.5.0"
  gem 'selenium-webdriver', '~> 2.40.0'
  gem 'jasmine', "~> 2.0.0"
  gem 'jasmine-jquery-rails', git: "git@github.com:HugoLnx/jasmine-jquery-rails.git"
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

ruby "2.0.0"
