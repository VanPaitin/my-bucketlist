require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require 'database_cleaner'
require "minitest/reporters"
reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options),
                          Minitest::Reporters::SpecReporter.new(reporter_options)]
DatabaseCleaner.clean_with :truncation

DatabaseCleaner.strategy = :transaction
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml
  # for all tests in alphabetical order.
  include FactoryGirl::Syntax::Methods
  # fixtures :all
  # Add more helper methods to be used by all tests here...
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def user
    build(:user)
  end
end
class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end


