source 'https://rubygems.org'

gem 'rails', '4.2.6'

gem 'rails-api'

gem 'spring', :group => :development
gem 'active_model_serializers'

gem 'sqlite3'
gem 'bcrypt', '~> 3.1.7'

gem "jwt"
# To use ActiveModel has_secure_password

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :development, :test do
  gem "rubocop"
  gem "pry-rails"
  gem "pry-nav"
  gem "factory_girl_rails"
end
group :test do
  gem 'database_cleaner'
  gem "minitest-around"
  gem "minitest-stub_any_instance"
  gem "faker"
end
