source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'rails-api'
gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem "jwt"
gem 'spring', :group => :development
gem "codeclimate-test-reporter", group: :test, require: nil
group :production do
  gem "pg"
  gem 'rails_12factor'
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
  gem "minitest-reporters"
  gem "minitest-stub_any_instance"
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
end
