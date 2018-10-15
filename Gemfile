source 'https://rubygems.org'
ruby "2.5.1"
gem 'rails', '4.2.10'
gem 'rails-api'
gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem "jwt"
gem 'spring', :group => :development
gem 'rack-cors', :require => 'rack/cors'
group :production do
  gem "pg", '~> 0.20'
  gem 'rails_12factor'
  gem 'puma'
end
group :development, :test do
  gem "factory_girl_rails"
  gem "faker"
  gem "pry-nav"
  gem "pry-rails"
  gem "rubocop"
  gem 'sqlite3'
end

group :test do
  gem 'database_cleaner'
  gem "minitest-around"
  gem "minitest-rails"
  gem "minitest-reporters"
  gem "minitest-stub_any_instance"
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
  gem 'simplecov'
end
